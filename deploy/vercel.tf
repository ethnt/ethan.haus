resource "vercel_project" "ethan_haus" {
  name      = "ethan-haus"
  framework = "astro"

  git_repository = {
    type = "github"
    repo = "ethnt/ethan.haus"
  }

  git_comments = {
    on_commit       = false
    on_pull_request = false
  }

  preview_comments = false
}

resource "vercel_project_domain" "ethan_haus" {
  project_id = vercel_project.ethan_haus.id
  domain     = "ethan.haus"
}
