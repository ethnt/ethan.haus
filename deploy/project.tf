resource "render_static_site" "ethan_haus" {
  name          = "ethan.haus"
  repo_url      = "https://github.com/ethnt/ethan.haus"
  build_command = "pnpm install --frozen-lockfile; pnpm run build"

  branch       = "main"
  publish_path = "./dist"
  auto_deploy  = true
}
