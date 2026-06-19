---
title: Search
author: Victor Silva
layout: page
permalink: /search/
---

<div id="search-container">
  <label for="search-input" class="sr-only">Buscar en el blog</label>
  <input type="text" id="search-input" placeholder="Search for interesting stuff... or maybe not...">
  <ul id="results-container" aria-live="polite" aria-label="Resultados de búsqueda"></ul>
</div>

<script defer src="{{ '/assets/js/jekyll-search.min.js' | relative_url }}"></script>
<script type="text/javascript">
SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/search.json',
  searchResultTemplate: '<li><a href="{url}" title="{desc}">{title}</a></li>',
  limit: 50,
})
</script>