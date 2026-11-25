---
title: Search
author: Victor Silva
layout: page
permalink: /search/
---

<div id="search-container">
  <label for="search-input" class="sr-only">Search the blog</label>
  <input type="text" id="search-input" placeholder="Search for interesting stuff... or maybe not...">
  <ul id="results-container" aria-live="polite" aria-label="Search results"></ul>
</div>

<script defer src="{{ '/assets/js/jekyll-search.min.js' | relative_url }}"></script>
<script>
// The library is deferred, so wait until it has run before initializing
document.addEventListener('DOMContentLoaded', function () {
  SimpleJekyllSearch({
    searchInput: document.getElementById('search-input'),
    resultsContainer: document.getElementById('results-container'),
    json: '{{ "/search.json" | relative_url }}',
    searchResultTemplate: '<li><a href="{url}" title="{desc}">{title}</a></li>',
    noResultsText: '<li class="search-empty">No results found</li>',
    limit: 50,
  });
});
</script>