return {
  "L3MON4D3/LuaSnip",
  version = "v2.*", 
  build = "make install_jsregexp", 
  dependencies = { "rafamadriz/friendly-snippets" }, 
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    -- HTML Snippets
    ls.add_snippets("html", {
      s("!", {
        t({
          "<!DOCTYPE html>",
          '<html lang="en">',
          "<head>",
          '    <meta charset="UTF-8">',
          '    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
          "    <title>",
        }),
        i(1, "Document"),
        t({
          "</title>",
          "</head>",
          "<body>",
          "    ",
        }),
        i(0),
        t({
          "",
          "</body>",
          "</html>",
        }),
      })
    })

    -- C++ Snippets
    ls.add_snippets("cpp", {
      -- Basic C++ snippet (Trigger: cpp)
      s("cpp", {
        t({
          "#include <iostream>",
          "",
          "int main() {",
          "    ", 
        }),
        i(0),  
        t({
          "",
          "    return 0;",
          "}",
        }),
      }),

      -- Codeforces C++ snippet (Trigger: forces)
      s("forces", {
        t({
          "#include <bits/stdc++.h>",
          "using namespace std;",
          "",
          "// Type Aliases",
          "using ll = long long;",
          "using vi = vector<int>;",
          "using vll = vector<long long>;",
          "",
          "void solve() {",
          "    ",
        }),
        i(1, "// Your code here"),
        t({
          "",
          "}",
          "",
          "int main() {",
          "    // Fast I/O",
          "    ios_base::sync_with_stdio(false);",
          "    cin.tie(NULL);",
          "    ",
          "    int t = 1;",
          "    cin >> t;",
          "    ",
          "    while (t--) {",
          "        solve();",
          "    }",
          "    ",
          "    return 0;",
          "}",
        }),
        i(0), -- Explicit final destination node
      })
    })
  end,
}
