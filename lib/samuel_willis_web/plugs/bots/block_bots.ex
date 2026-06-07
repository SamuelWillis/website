defmodule SamuelWillisWeb.Plugs.Bots.BlockBots do
  @moduledoc """
  Blocks known AI Bot User Agent requests via a 403 response.

  Halt is needed to ensure that the plug pipeline does not continue and the
  router is not reached.
  """

  import Plug.Conn

  # Compiled once at compile time — not per-request
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
