---
title: About
author: Victor Silva
layout: page-wide
permalink: /about/
---

<div class="row-grid">
  <div class="center">
    <p>Hi, I'm <b><i>Victor Silva</i></b>, a software engineer with a passion for development and security. I'm currently working at <a class="bounce-link" href="https://www.mercadolibre.com">Mercado Libre</a> as a Cloud Security Engineer. You can check out my personal blog <a class="bounce-link" href="https://blog.victorsilva.com.uy">$blogTopics | % {echo $_}</a></p>
  </div>
  <div class="center">
    <picture>
      <source srcset="{{ site.author.about-photo | replace: '.jpg', '.webp' }}" type="image/webp">
      <img class="about-image" src="{{ site.author.about-photo }}" alt="{{ site.author.name }}" loading="lazy">
    </picture>
  </div>
</div>
