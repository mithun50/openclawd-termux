package com.openclawd.app

import android.content.Context
import android.system.Os
import java.io.BufferedInputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.zip.GZIPInputStream
import org.apache.commons.compress.archivers.tar.TarArchiveEntry
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream

class BootstrapManager(
    private val context: Context,
    private val filesDir: String,
    private val nativeLibDir: String
) {
    private val rootfsDir get() = "$filesDir/rootfs/ubuntu"
    private val tmpDir get() = "$filesDir/tmp"
    private val homeDir get() = "$filesDir/home"
    private val configDir get() = "$filesDir/config"
    private val libDir get() = "$filesDir/lib"

    fun setupDirectories() {
        listOf(rootfsDir, tmpDir, homeDir, configDir, "$homeDir/.openclawd", libDir).forEach {
            File(it).mkdirs()
        }
        // Termux's proot links against libtalloc.so.2 but Android extracts it
        // as libtalloc.so (jniLibs naming convention). Create a copy with the
        // correct SONAME so the dynamic linker finds it.
        setupLibtalloc()
    }

    private fun setupLibtalloc() {
        val source = File("$nativeLibDir/libtalloc.so")
        val target = File("$libDir/libtalloc.so.2")
        if (source.exists() && !target.exists()) {
            source.copyTo(target)
            target.setExecutable(true)
        }
    }

    fun isBootstrapComplete(): Boolean {
        val rootfs = File(rootfsDir)
        val binBash = File("$rootfsDir/bin/bash")
        val bypass = File("$rootfsDir/root/.openclawd/bionic-bypass.js")
        return rootfs.exists() && binBash.exists() && bypass.exists()
    }

    fun getBootstrapStatus(): Map<String, Any> {
        val rootfsExists = File(rootfsDir).exists()
        val binBashExists = File("$rootfsDir/bin/bash").exists()
        val nodeExists = checkNodeInProot()
        val openclawExists = checkOpenClawInProot()
        val bypassExists = File("$rootfsDir/root/.openclawd/bionic-bypass.js").exists()

        return mapOf(
            "rootfsExists" to rootfsExists,
            "binBashExists" to binBashExists,
            "nodeInstalled" to nodeExists,
            "openclawInstalled" to openclawExists,
            "bypassInstalled" to bypassExists,
            "rootfsPath" to rootfsDir,
            "complete" to (rootfsExists && binBashExists && bypassExists)
        )
    }

    fun extractRootfs(tarPath: String) {
        val rootfs = File(rootfsDir)
        rootfs.mkdirs()

        // Pure Java extraction using Apache Commons Compress.
        // Avoids all proot/tar compatibility issues with Android kernels.
        // Hard links are converted to symlinks (like proot --link2symlink).
        FileInputStream(tarPath).use { fis ->
            BufferedInputStream(fis, 256 * 1024).use { bis ->
                GZIPInputStream(bis).use { gis ->
                    TarArchiveInputStream(gis).use { tis ->
                        var entry: TarArchiveEntry? = tis.nextEntry
                        while (entry != null) {
                            val name = entry.name
                                .removePrefix("./")
                                .removePrefix("/")

                            // Skip empty names and /dev entries
                            if (name.isEmpty() || name.startsWith("dev/") || name == "dev") {
                                entry = tis.nextEntry
                                continue
                            }

                            val outFile = File(rootfsDir, name)

                            when {
                                entry.isDirectory -> {
                                    outFile.mkdirs()
                                }
                                entry.isSymbolicLink -> {
                                    outFile.parentFile?.mkdirs()
                                    try {
                                        if (outFile.exists() || isSymlink(outFile)) {
                                            outFile.delete()
                                        }
                                        Os.symlink(entry.linkName, outFile.absolutePath)
                                    } catch (_: Exception) {}
                                }
                                entry.isLink -> {
                                    // Hard link → symlink (same as --link2symlink)
                                    outFile.parentFile?.mkdirs()
                                    val target = entry.linkName
                                        .removePrefix("./")
                                        .removePrefix("/")
                                    try {
                                        if (outFile.exists() || isSymlink(outFile)) {
                                            outFile.delete()
                                        }
                                        // Use absolute path within rootfs so it works
                                        // both on host and inside proot
                                        val targetFile = File(rootfsDir, target)
                                        if (targetFile.exists()) {
                                            Os.symlink(targetFile.absolutePath, outFile.absolutePath)
                                        }
                                    } catch (_: Exception) {}
                                }
                                else -> {
                                    // Regular file
                                    outFile.parentFile?.mkdirs()
                                    FileOutputStream(outFile).use { fos ->
                                        val buf = ByteArray(65536)
                                        var len: Int
                                        while (tis.read(buf).also { len = it } != -1) {
                                            fos.write(buf, 0, len)
                                        }
                                    }
                                    // Preserve execute permission
                                    if (entry.mode and 0b001_001_001 != 0) {
                                        outFile.setExecutable(true, false)
                                    }
                                    if (entry.mode and 0b010_010_010 != 0) {
                                        outFile.setWritable(true, false)
                                    }
                                    if (entry.mode and 0b100_100_100 != 0) {
                                        outFile.setReadable(true, false)
                                    }
                                }
                            }

                            entry = tis.nextEntry
                        }
                    }
                }
            }
        }

        // Verify extraction
        if (!File("$rootfsDir/bin/bash").exists()) {
            throw RuntimeException("Extraction failed: /bin/bash not found in rootfs")
        }

        // Clean up tarball
        File(tarPath).delete()
    }

    private fun isSymlink(file: File): Boolean {
        return try {
            val canonical = file.canonicalFile
            val absolute = file.absoluteFile
            canonical.path != absolute.path
        } catch (_: Exception) {
            false
        }
    }

    fun installBionicBypass() {
        val bypassDir = File("$rootfsDir/root/.openclawd")
        bypassDir.mkdirs()

        val bypassContent = """
// OpenClawd Bionic Bypass - Auto-generated
const os = require('os');
const originalNetworkInterfaces = os.networkInterfaces;

os.networkInterfaces = function() {
  try {
    const interfaces = originalNetworkInterfaces.call(os);
    if (interfaces && Object.keys(interfaces).length > 0) {
      return interfaces;
    }
  } catch (e) {
    // Bionic blocked the call, use fallback
  }

  // Return mock loopback interface
  return {
    lo: [
      {
        address: '127.0.0.1',
        netmask: '255.0.0.0',
        family: 'IPv4',
        mac: '00:00:00:00:00:00',
        internal: true,
        cidr: '127.0.0.1/8'
      }
    ]
  };
};
""".trimIndent()

        File("$rootfsDir/root/.openclawd/bionic-bypass.js").writeText(bypassContent)

        // Patch .bashrc
        val bashrc = File("$rootfsDir/root/.bashrc")
        val exportLine = "export NODE_OPTIONS=\"--require /root/.openclawd/bionic-bypass.js\""

        val existing = if (bashrc.exists()) bashrc.readText() else ""
        if (!existing.contains("bionic-bypass")) {
            bashrc.appendText("\n# OpenClawd Bionic Bypass\n$exportLine\n")
        }
    }

    fun writeResolvConf() {
        val configDir = File(this.configDir)
        configDir.mkdirs()

        File("$configDir/resolv.conf").writeText("nameserver 8.8.8.8\nnameserver 8.8.4.4\n")
    }

    private fun checkNodeInProot(): Boolean {
        return try {
            val pm = ProcessManager(filesDir, nativeLibDir)
            val output = pm.runInProotSync("node --version")
            output.trim().startsWith("v")
        } catch (e: Exception) {
            false
        }
    }

    private fun checkOpenClawInProot(): Boolean {
        return try {
            val pm = ProcessManager(filesDir, nativeLibDir)
            val output = pm.runInProotSync("command -v openclaw")
            output.trim().isNotEmpty()
        } catch (e: Exception) {
            false
        }
    }
}
