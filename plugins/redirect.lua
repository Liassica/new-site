-- Author: Liassica
-- License: Apache 2.0

Plugin.require_version("4.0.0")

base_url = config["base_url"]

if not config["base_url"] then
  Plugin.fail("base_url option must be specified")
end

if not config["redirect_template"] then
  Plugin.fail("redirect_template option must be specified")
end

env = {}

url = HTML.select_one(page, "url")
url_content = HTML.inner_html(url)

-- If a <url> element is specified, redirect to the relative link inside it.
-- Otherwise, redirect to the current page's relative URL
if url then
  redirect_url = base_url .. url_content
  HTML.delete(url)
else
  page_url = Regex.replace_all(page_url, "(\\..*)", "")
  redirect_url = base_url .. page_url
end

env["redirect_url"] = redirect_url

link = HTML.select_one(page, "#url")
HTML.set_attribute(link, "href", redirect_url)
href = HTML.parse(redirect_url)
HTML.append_child(link, href)

tmpl = config["redirect_template"]
head = HTML.select_one(page, "head")
meta = HTML.parse(String.render_template(tmpl, env))
HTML.append_child(head, meta)