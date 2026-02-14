class SitemapRefreshJob < ApplicationJob
  queue_as :low

  def perform
    SitemapGenerator::Interpreter.run
    SitemapGenerator::Sitemap.ping_search_engines
  end
end
