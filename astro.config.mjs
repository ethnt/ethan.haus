/** @type {import('astro').AstroUserConfig} */
// @ts-check
import { defineConfig } from "astro/config";

import vercel from "@astrojs/vercel";

// https://astro.build/config
export default defineConfig({
  output: "static",
  site: "https://ethan.haus",
  adapter: vercel({
    imageService: true
  })
});
