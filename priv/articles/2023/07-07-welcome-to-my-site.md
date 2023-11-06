%{
  title: "Journeys in building a website",
  author: "Samuel Willis",
  tags: ~w(projects elixir phoenix),
  description: "What I did to build a website after numerous false starts.",
  published: true
}
---
Several months ago I decided I wanted to build a website for myself again. After
letting my previous [Vue.JS site](https://github.com/SamuelWillis/samuel-willis)
fall into neglect I felt it was time to spruce things up and maybe try a
different technology

I wanted to prioritise development ease and simplicity. I also wanted to be able
to write blog posts and keep the writing for myself.

Thus I began looking at a bunch of different options, eventually settling on
[building a site with
Hugo](https://github.com/SamuelWillis/samuelwillis.github.io).

I got a theme and wrote up some blog posts and promptly fell off the wagon. The
site just wasn't sitting well with me, the styles weren't quite there, the
workflow to writing and deploying posts was a bit cumbersome.

So I decided to start again, [Nuxt](https://nuxt.com/) seemed like a great
choice! I should also brush up those Vue skills I thought. I fired up a branch,
saying "I'll keep it simple this time". 4 months later, still no new website.
"Oh I just need to style this", "Oh I just need to fine tune that" and on the
excuses went.

Then it hit me, I was approaching my projects with the idea of hitting a place
that was "just right" before moving forward with it. I was also choosing
technologies that would get in my way, rather than ones that would help me get
to my goal _releasing a small website that I could write blog posts on_.

So I decided to change my approach.

---

Rather than choosing a technology to "try" or "brush up on" I stuck with
Elixir's [Phoenix framework](https://www.phoenixframework.org/), which is
incredibly easy to install and get running.
It also comes with [Tailwind CSS](https://tailwindcss.com/) taking the CSS
legwork out of the equation.

My first priority was deploying. Specifically _continuously deploying_. I didn't
want PRs and merges and finding ways to delay putting things out there. Luckily
[fly.io](https://fly.io/) makes it incredibly easy to deploy a Phoenix
application, and doing so via [GitHub
Actions](https://fly.io/docs/app-guides/continuous-deployment-with-github-actions/)
is a breeze.

In about a hour I had a deployed website! Granted it was the "Welcome to the
Phoenix Framework" base application, but it was live and making changes would be
incredibly easy.


---

## So what's next?

Well if you're reading this, I definitely restyled from a base Phoenix App. And
I likely got a method of publishing set up!

Maybe there's styling, maybe there's even navigation to this page, I'm not sure.
What I do know is that I'll be able to add those things quickly and easily
because the way I've set this project up emphasizes making small changes that go
live as quickly as I can make a commit.

Stay tuned! I'm confident there will be more to come.
