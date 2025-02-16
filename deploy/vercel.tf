resource "vercel_project" "ethan_haus" {
  name = "ethan-haus"
  framework = "astro"

  git_repository = {
    type = "github"
    repo = "ethnt/ethan.haus"
  }
}
