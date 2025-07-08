import { file } from "astro/loaders";
import { defineCollection, z } from "astro:content";

const cvItemSchema = z.object({
  name: z.string(),
  description: z.string(),
  url: z.string(),
  start_date: z.coerce.date().optional(),
  end_date: z.coerce.date().optional().nullable()
});

export type CVItem = z.infer<typeof cvItemSchema>;

const experiences = defineCollection({
  loader: file("src/content/data/experiences.json"),
  schema: cvItemSchema
});

const educations = defineCollection({
  loader: file("src/content/data/educations.json"),
  schema: cvItemSchema
});

const projects = defineCollection({
  loader: file("src/content/data/projects.json"),
  schema: cvItemSchema
});

const contact_links = defineCollection({
  loader: file("src/content/data/contact-links.json"),
  schema: z.object({
    label: z.string(),
    url: z.string(),
    text: z.string()
  })
});

export const collections = { experiences, educations, projects, contact_links };
