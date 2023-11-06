%{
  title: "Building a Markdown Blog with NimblePublisher",
  author: "Samuel Willis",
  tags: ~w(projects elixir phoenix),
  description: "Learn how I added a markdown blog to my website with the Elixir Phoenix framework for dynamic and maintainable content.",
  published: true
}
---
In this post, I'm picking up where I left off in the journey of building my
site. If you're just joining, consider reading the [first
part](/articles/welcome-to-my-site) where I lay out the tech stack and
development lifecycle decisions for my website.
It's a good setup for today's focus: integrating a markdown based blog.

---

A main motivation for this website is to provide a space to write and publish
short articles about software development, hence the need for a straightforward
way to write and publish articles.

I aimed for simplicity.
Writing and publishing should be hassle-free, without any convoluted processes.

Preferring to avoid CMS as a Service due to the extra steps and potential
complexity, I wanted something that fit seamlessly into my existing workflow.

## Discovering NimblePublisher

My quest for a CMS that fit with Elixir brought me to
[NimblePublisher](https://hexdocs.pm/nimble_publisher/NimblePublisher.html) by
[Dashbit](https://dashbit.co/), discovered through an [Elixir forum
thread](https://elixirforum.com/t/go-to-headless-cms-for-elixir-and-phoenix/45400).
Dashbit's [own
write-up](https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made) convinced
me it was the ideal solution.

It allowed markdown articles to be part of the codebase, with continuous
deployment taking care of publishing. It seemed perfect.

## Implementing NimblePublisher

Setting up NimblePublisher was straightforward. The [official
documentation](https://hexdocs.pm/nimble_publisher/NimblePublisher.html)
provided clear steps, which basically boiled down to:

1. Adding `NimblePublisher` as a dependency
2. Configuring the dev `Endpoint` for live reloading markdown files
3. Setting up a `Blog` context and `Article` struct
4. Drafting an initial Hello World post

My implementation is available
[here](https://github.com/SamuelWillis/samuelwillis.dev/commit/1df8a01bb87bef6daacd2d193fdc5df3d8b01cdf).

## Creating Blog Post Endpoints

With the ability to write and parse markdown, I needed to display the articles.
I added `index` to list articles and `show` to display a specific one.

Phoenix made this addition straightforward.

See the [source
code](https://github.com/SamuelWillis/samuelwillis.dev/commit/73af78b0e41a7abbe37bf948a90966b9a53553c6)
for more details.

## Styling Article Pages

Syntax highlighting was the first order of business.
Makeup, suggested by NimblePublisher, required generating a stylesheet to
incorporate into the app's CSS.
It's a simple command:

```elixir
iex(1)> Makeup.stylesheet(:monokai_style)
```

The generated styles were then merged into the `app.css` styles.

For the full implementation, refer to the [source
code](https://github.com/SamuelWillis/samuelwillis.dev/commit/a844b02a199f5439516a8b36e6ce48e947825b5c).

Next, typography.
TailwindCSS, included in Phoenix by default, combined with the
[TailwindCSS typography plugin](https://tailwindcss.com/docs/typography-plugin),
provides great typography styling out of the box.

Integrating the TailwindCSS typography styles with the generated Makeup style
took a bit of fiddling, but adjusting the Tailwind config did the trick.

```js
// tailwind.config.js
// ...imports

module.exports = {
  // ... rest of config
  theme: {
    extend: {
      css: {
        // ... theme config
        typography:(theme) => ({
          DEFAULT: {
            pre: {
              // I had to set these values to match the background in the Makeup
              // styles
              "background-color": "#F0F0F0",
              color: "currentcolor"
            },
            code: null,
            'code::before': null,
            'code::after': null,
            'pre code': null,
            'pre code::before': null,
            'pre code::after': null
          },
        },
      },
    },
  },
};
```

## Conclusion

Phoenix's ecosystem effortlessly supported the creation of a markdown blog. It's
straightforward, without the complexities of full-fledged CMSs, and it meshes
well with my workflow.

My articles are in markdown, version-controlled, and self-owned. The writing and
publishing process is akin to coding, which eases the path from draft to
publication.

If you're looking for a way to add a simple markdown based blog to your Phoenix
project, I couldn't recommend this set up more.
