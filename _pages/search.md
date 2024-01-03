---
title: Search
author: Victor Silva
layout: default
permalink: /search/
---
<article class="post">
  <h1 class="underline">Search</h1>
  <div id="search-container">
    <input type="text" id="search-input" placeholder="search...">
    <ul id="results-container"></ul>
  </div>
</article>

<script src="/assets/jekyll-search.min.js" type="text/javascript"></script>
<script type="text/javascript">
SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/search.json',
  searchResultTemplate: '<li><a href="{url}" title="{desc}">{title}</a></li>',
  limit: 50,
})
</script>