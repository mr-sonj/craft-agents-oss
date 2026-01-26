<<<<<<< HEAD
/**
 * Cross-platform resources copy script
 */

import { existsSync, cpSync } from "fs";
import { join } from "path";

const ROOT_DIR = join(import.meta.dir, "..");
const ELECTRON_DIR = join(ROOT_DIR, "apps/electron");

const srcDir = join(ELECTRON_DIR, "resources");
const destDir = join(ELECTRON_DIR, "dist/resources");

if (existsSync(srcDir)) {
  cpSync(srcDir, destDir, { recursive: true, force: true });
  console.log("📦 Copied resources to dist");
} else {
  console.log("⚠️ No resources directory found");
}
=======
#!/usr/bin/env bun
import { $ } from 'bun';

console.log('📦 Copying Electron resources...');
await $`cd apps/electron && bun run build:resources && bun run build:assets`;
console.log('✅ Resources copied successfully');
>>>>>>> 00abdf0 (feat: update git workflow documentation and enhance sync scripts for better handling of dependencies and conflicts)
