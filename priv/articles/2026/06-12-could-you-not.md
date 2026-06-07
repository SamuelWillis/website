%{
  title: "Could you not? Stopping Bots from scraping my website",
  author: "Samuel Willis",
  tags: ~w(elixir phoenix plug robots.txt ai scraping data-sovereignity),
  description: "Stewarding access to your content.",
  published: true
}
---

In a [previous episode](/articles/web-crawling) I wrote about building a very
small and very simple webcrawler.

This got me thinking about what bots were accessing my website and what they are
using the content I work to produce for.

While I do not mind my data and content being searchable and found, I am
somewhat wary of having my data extracted and sold.

So, with the above two things in mind I became curious about what strategies
exist that can help mitigate bot access to your data

And I found a few that I ended up using in my [Phoenix based
website](https://github.com/SamuelWillis/website) you are currently reading this
article on.

Implementations will focus on AI Bots but the techniques can be applied to any
kind of bot you wish to prevent accessing your site!

# Robots.txt

Robots.txt is a formatted file that contains instructions for bots. Not all bots
will respect its directives though.

Out of the box Phoenix includes a base `robots.txt` that is served by the
`Plug.Static` in the `MyWebApp.Endpoint` module.

**Note:** If you have included the `only` option in your `Plug.Static`
configuration make sure it includes the `robot.txt`

Updating this to include [known AI User
Agents](https://github.com/ai-robots-txt/ai.robots.txt) along with whatever
other agents you want is a great first step.

Since `robots.txt` isn't enforced and scrapers don't always adhere to these
rules there's some further protections you can add.

# Specifying X Robots Tag & TDM Reservation

Specifying a X Robots Tag
[header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Robots-Tag) and
[meta](https://w3c-cg.github.io/tdm-reservation-protocol/spec/#sec-tdm-html-meta) meta tag
define how crawlers should index URLs.

[Here](https://www.ietf.org/archive/id/draft-canel-robots-ai-control-01.html) is
a proposal to extend the Robot Exclusion protocol and most sources seem to have
landed on `noai` and `noimageai`.

Similar, you can designat your TDM reservation in a meta and a header.

Toss this into your `root.html.heex`:

```html
<meta name="robots" content="noai, noimageai" />
<meta name="tdm-reservation" content="1" />
```

Then for your response headers you can add a neato plug like this:

```elixir
defmodule SamuelWillisWeb.Plugs.Bots.PutTDMReservationHeaders do
  @moduledoc """
  Sets XRobotsTag & TDM Reservation header.

  See [TDM Reservation
  Protocol](https://www.w3.org/community/reports/tdmrep/CG-FINAL-tdmrep-20240202/).

  See [X-Robots-Tag header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Ro bots-Tag).
  """
  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    conn
    |> put_resp_header("tdm-reservation", "1")
    |> put_resp_header("x-robots-tag", "noai, noimageai")
  end
end
```

# Hard blocking with a Plug

If you would like to apply a bit of a sledgehammer, you can add a Plug to
your pipeline that checks the request's user agent and returns a `403` if it
corresponds to a bot.

It does not handle bots that use a fake user agent but is a great bit of insurance
against the bots that may not respect the `robots.txt`.

Here's how it looks:

```elixir
defmodule MyWebApp.Plugs.BlockBots do
  @moduledoc """
  Blocks known AI Bot User Agent requests via a 403 response.

  Halt is needed to ensure that the plug pipeline does not continue and the
  router is not reached.
  """

  import Plug.Conn

  @blocked_ua_pattern ~r(AddSearchBot|AgentTimes|AI2Bot|AI2Bot-DeepResearchEval|Ai2Bot-Dolma|aiHitBot|amazon-kendra|Amazonbot|AmazonBuyForMe|Amzn-SearchBot|Amzn-User|Andibot|Anomura|anthropic-ai|ApifyBot|ApifyWebsiteContentCrawler|Applebot|Applebot-Extended|Aranet-SearchBot|atlassian-bot|Awario|AzureAI-SearchBot|bedrockbot|bigsur.ai|Bravebot|Brightbot|Brightbot 1.0|BuddyBot|Bytespider|CCBot|Channel3Bot|ChatGLM-Spider|ChatGPT Agent|ChatGPT-User|Claude-Code|Claude-SearchBot|Claude-User|Claude-Web|ClaudeBot|Cloudflare-AutoRAG|CloudVertexBot|Code|cohere-ai|cohere-training-data-crawler|Cotoyogi|Crawl4AI|Crawlspace|Datenbank Crawler|DeepSeekBot|Devin|Diffbot|DuckAssistBot|Echobot Bot|EchoboxBot|ExaBot|FacebookBot|facebookexternalhit|Factset_spyderbot|FirecrawlAgent|FriendlyCrawler|Gemini-Deep-Research|Google-Agent|Google-CloudVertexBot|Google-Extended|Google-Firebase|Google-Gemini-CLI|Google-NotebookLM|GoogleAgent-Mariner|GoogleOther|GoogleOther-Image|GoogleOther-Video|GPTBot|HenkBot|iAskBot|iaskspider|iaskspider/2.0|IbouBot|ICC-Crawler|ImagesiftBot|imageSpider|img2dataset|ISSCyberRiskCrawler|kagi-fetcher|Kangaroo Bot|KlaviyoAIBot|KunatoCrawler|laion-huggingface-processor|LAIONDownloader|LCC|LinerBot|Linguee Bot|LinkupBot|Manus-User|meta-externalagent|Meta-ExternalAgent|meta-externalfetcher|Meta-ExternalFetcher|meta-webindexer|MistralAI-User|MistralAI-User/1.0|MyCentralAIScraperBot|NagetBot|netEstate Imprint Crawler|newsai|NotebookLM|NovaAct|OAI-SearchBot|omgili|omgilibot|OpenAI|opencode|Operator|PanguBot|Panscient|panscient.com|Perplexity-User|PerplexityBot|PetalBot|PhindBot|Poggio-Citations|Poseidon Research Crawler|QualifiedBot|QuillBot|quillbot.com|SBIntuitionsBot|Scrapy|SemrushBot-OCOB|SemrushBot-SWA|Shap-User|ShapBot|Sidetrade indexer bot|Spider|TavilyBot|Terra Cotta|TerraCotta|Thinkbot|TikTokSpider|Timpibot|Trae|TwinAgent|VelenPublicWebCrawler|WARDBot|Webzio-Extended|webzio-extended|wpbot|WRTNBot|YaK|YandexAdditional|YandexAdditionalBot|YouBot|ZanistaBot)i

  def init(opts), do: opts

  def call(conn, _opts) do
    user_agent =
      conn
      |> get_req_header("user-agent")
      |> List.first("")

    if Regex.match?(@blocked_ua_pattern, user_agent) do
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    else
      conn
    end
  end
end
```

Add the above plug into your `Endpoint` module after the `Plug.Static` and
before the `Plug.Router` so that the `robots.txt` is still served.

```elixir
defmodule MyWebApp.Endpoint do
  # ...
  plug Plug.Static,
    at: "/",
    from: :my_app,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)
    
  plug MyAppWeb.Plugs.Bots.BlockAiBots
  plug MyAppWeb.Router
end
```

# Conclusion

There's not a sure fire way to block all bot traffic to your site and, in fact,
you probably don't want to do that.
However, the above approaches are a good start to begin stewarding access to
your content and, as per usual, Phoenix makes it super easy to implement them.

There's other options too but these ones lemme show y'all a bit of Elixir ;)

