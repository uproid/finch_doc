var mapTemplates = {
	r"template/navbar.html.twig": r"""{% block navbar %}
<!-- Skip to content for accessibility -->
<a href="#main-content" class="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:start-2 focus:z-50 focus:px-4 focus:py-2 focus:bg-blue-600 focus:text-white focus:rounded-lg">
    {{ $t('Skip to content') }}
</a>

<!-- Top Navigation Bar -->
<nav class="fixed top-0 start-0 end-0 z-50 bg-white/80 dark:bg-gray-800/80 backdrop-blur-md border-b border-gray-200 dark:border-gray-700 shadow-sm" role="navigation" aria-label="Main navigation">
    <!-- Reading progress bar -->
    <div id="readingProgress" class="absolute bottom-0 start-0 h-0.5 bg-linear-to-r from-blue-500 to-purple-500 dark:from-secondary-400 dark:to-purple-400 transition-all duration-300" style="width: 0%"></div>
    
    <div class="max-w-[1600px] mx-auto flex items-center justify-between px-4 h-16">
        <!-- Left: Logo & Menu Toggle -->
        <div class="flex items-center gap-4">
            <button id="menuToggle" class="lg:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" aria-label="Toggle navigation menu" aria-expanded="false">
                <i class="ph-bold ph-list text-xl leading-none"></i>
            </button>
            <a href="/" class="flex items-center gap-2 group">
                <img src="/logo.svg" alt="Finch Framework Logo" class="h-10 group-hover:scale-110 transition-transform">
                <span class="font-bold text-xl hidden sm:block">{{ $t('Finch') }}</span>
                <span class="text-gray-500 dark:text-gray-400 text-xs px-2 py-0.5 rounded-full bg-gray-100 dark:bg-gray-700">v{{ finchVersion }}</span>
            </a>
        </div>

        <!-- Center: Search Bar -->
        <div class="flex-1 max-w-2xl mx-4 hidden md:block">
            <div class="relative">
                <input 
                    type="text" 
                    id="searchInput"
                    placeholder="{{ $t('Search documentation...') }}" 
                    class="w-full px-4 py-2 ps-10 pe-24 rounded-lg border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 focus:outline-none focus:border transition-all"
                    autocomplete="off"
                    role="searchbox"
                    aria-label="Search documentation"
                >
                <i class="ph-bold ph-magnifying-glass absolute start-3 top-1/2 transform -translate-y-1/2 text-xl text-gray-400"></i>
                <div class="absolute end-3 top-1/2 transform -translate-y-1/2 flex items-center gap-2">
                    <kbd class="hidden lg:inline-flex px-2 py-1 text-xs bg-gray-200 dark:bg-gray-600 rounded font-mono">Ctrl</kbd>
                    <kbd class="hidden lg:inline-flex px-2 py-1 text-xs bg-gray-200 dark:bg-gray-600 rounded font-mono">K</kbd>
                </div>
                
                <!-- Search Results Dropdown -->
                <div id="searchResults" class="hidden absolute top-full start-0 end-0 mt-2 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 max-h-96 overflow-y-auto z-50" role="listbox">
                    <!-- Results will be inserted here -->
                </div>
            </div>
        </div>

        <!-- Right: Actions -->
        <div class="flex items-center gap-2">
            <!-- Tools Dropdown -->
            <div class="relative group">
                <button id="toolsDropdown" class="hidden md:flex items-center gap-1.5 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" aria-haspopup="true" aria-expanded="false">
                    <span class="text-sm font-medium">{{ $t('Help') }}</span>
                    <i class="ph-bold ph-caret-down text-xs leading-none translate-y-px"></i>
                </button>
                
                <!-- Dropdown Menu -->
                <div id="toolsMenu" class="hidden absolute end-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 py-2 z-50" role="menu">
                    <a href="{{ configs.otherPackages }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" role="menuitem">
                        <i class="ph-bold ph-package text-lg"></i>
                        <div class="font-medium text-sm">{{ $t('Other Packages') }}</div>
                    </a>
                    <a href="{{ configs.releases }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" role="menuitem">
                        <i class="ph-bold ph-git-branch text-lg"></i>
                        <div class="font-medium text-sm">{{ $t('Finch Releases') }}</div>
                    </a>
                    <a href="{{ configs.changelog }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" role="menuitem">
                        <i class="ph-bold ph-list-bullets text-lg"></i>
                        <div class="font-medium text-sm">{{ $t('Changelog') }}</div>
                    </a>
                    <a href="{{ configs.sponsor }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" role="menuitem">
                        <i class="ph-bold ph-lifebuoy text-lg"></i>
                        <div class="font-medium text-sm">{{ $t('Support') }}</div>
                    </a>
                </div>
            </div>

            <!-- Mobile Search -->
            <button id="mobileSearchToggle" class="md:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" aria-label="Open search">
                <i class="ph-bold ph-magnifying-glass text-xl leading-none"></i>
            </button>
            
            <!-- MCP -->
            <a href="{{ $e.url('mcp-server') }}" rel="noopener noreferrer" class=" sm:flex items-center p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors {{ $l.isRouteKey('home.mcpserver.index') ? 'bg-blue-50 dark:bg-gray-900' : '' }} " aria-label="View on GitHub">
                <i class="text-xl leading-none text-black dark:text-white">
                    <svg width="20" height="20" viewBox="0 0 180 180" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <g>
                            <path d="M18 84.8528L85.8822 16.9706C95.2548 7.59798 110.451 7.59798 119.823 16.9706V16.9706C129.196 26.3431 129.196 41.5391 119.823 50.9117L68.5581 102.177" stroke="currentColor" stroke-width="12" stroke-linecap="round"/>
                            <path d="M69.2652 101.47L119.823 50.9117C129.196 41.5391 144.392 41.5391 153.765 50.9117L154.118 51.2652C163.491 60.6378 163.491 75.8338 154.118 85.2063L92.7248 146.6C89.6006 149.724 89.6006 154.789 92.7248 157.913L105.331 170.52" stroke="currentColor" stroke-width="12" stroke-linecap="round"/>
                            <path d="M102.853 33.9411L52.6482 84.1457C43.2756 93.5183 43.2756 108.714 52.6482 118.087V118.087C62.0208 127.459 77.2167 127.459 86.5893 118.087L136.794 67.8822" stroke="currentColor" stroke-width="12" stroke-linecap="round"/>
                        </g>
                    </svg>
                </i>
            </a>

            <!-- GitHub with star count -->
            <a href="{{ configs.repository }}" target="_blank"  rel="noopener noreferrer" class="hidden sm:flex items-center p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" aria-label="View on GitHub">
                <i class="ph-bold ph-github-logo text-xl leading-none"></i>
            </a>


            <!-- Theme Toggle -->
            <button id="themeToggle" class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer transition-colors flex items-center justify-center" aria-label="Toggle theme">
                <i id="theme-icon-light" class="ph-bold ph-moon text-xl leading-none" style="display: inline-block;"></i>
                <i id="theme-icon-dark" class="ph-bold ph-sun text-xl leading-none" style="display: none;"></i>
            </button>

            <!-- Language Dropdown -->
            <div class="relative group">
                <button id="languageDropdown" class="flex items-center gap-1.5 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors" aria-haspopup="true" aria-expanded="false" aria-label="Select language">
                    <i class="ph-bold ph-translate text-xl leading-none"></i>
                    <span class="hidden lg:inline text-sm font-medium uppercase">{{ $e.ln }}</span>
                </button>
                
                <!-- Language Menu -->
                <div id="languageMenu" class="hidden absolute end-0 mt-1 w-48 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 z-50 overflow-hidden" role="menu">
                    {% for lang in languages %}
                    <a href="/{{ lang.code }}/{{ key }}" data-lang="{{ lang.code }}" class="{{ $e.ln == lang.code ? 'text-blue-600 dark:text-secondary-400 bg-blue-50 dark:bg-gray-900 font-semibold' : '' }} flex items-center gap-3 px-4 py-2.5 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors" role="menuitem">
                        <div class="flex-1">
                            <div class="font-medium text-sm">{{ lang.localName }}</div>
                            <div class="text-xs text-gray-500 dark:text-gray-400">{{ lang.name }}</div>
                        </div>
                        {% if $e.ln == lang.code %}
                        <i class="ph-bold ph-check text-lg"></i>
                        {% endif %}
                    </a>
                    {% endfor %}
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- Mobile Search Modal -->
<div id="mobileSearchModal" class="hidden fixed inset-0 bg-black/50 z-50 md:hidden">
    <div class="bg-white dark:bg-gray-800 p-2 pb-0 pt-3">
        <div class="flex items-center gap-2 mb-4">
            <input 
                type="text" 
                id="mobileSearchInput"
                placeholder="{{ $t('Search documentation...') }}" 
                class="flex-1 px-4 py-2 ps-10 rounded-lg border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400"
                autocomplete="off"
            >
            <button id="closeMobileSearch" class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
                <i class="ph-bold ph-x text-2xl"></i>
            </button>
        </div>
        <div id="mobileSearchResults" class="bg-white dark:bg-gray-800 rounded-lg max-h-96 overflow-y-auto">
            <!-- Mobile results will be inserted here -->
        </div>
    </div>
</div>
{% endblock %}""",
	r"template/head.html.twig": r"""{% block head %}
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-D6J35LTEMC"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-D6J35LTEMC');
</script>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{% block title %}{{ title }}{% endblock %} | Finch</title>
{% if description is defined %}
<meta name="description" content="{% block description %}{{ description }}{% endblock %}">
{% else %}
<meta name="description" content="Finch helps developers build scalable Dart backends with MongoDB, MySQL, SQLite, WebSockets, auto API docs, authentication, email, and deployment tools.">
{% endif %}
<meta name="keywords" content="Dart backend framework, Dart web development, scalable backend, MongoDB Dart, MySQL Dart, SQLite Dart, WebSockets Dart, real-time API, Swagger documentation, API authentication, email integration, microservices Dart, enterprise backend, deployment tools">
<link rel="icon" href="/favicon.ico" type="image/x-icon">
<link rel="sitemap" type="application/xml" title="Sitemap" href="/sitemap.xml">
<meta name="robots" content="index, follow">
<script>
    (function () {
        const theme = localStorage.getItem('theme') || 'light';
        if (theme === 'dark') {
            document.documentElement.classList.add('dark');
        }
        
        // Initialize theme icons when DOM is ready
        window.addEventListener('DOMContentLoaded', function() {
            const isDark = document.documentElement.classList.contains('dark');
            const themeIconLight = document.getElementById('theme-icon-light');
            const themeIconDark = document.getElementById('theme-icon-dark');
            
            // Set theme icons
            if (themeIconLight && themeIconDark) {
                if (isDark) {
                    themeIconLight.style.display = 'none';
                    themeIconDark.style.display = 'inline-block';
                } else {
                    themeIconLight.style.display = 'inline-block';
                    themeIconDark.style.display = 'none';
                }
            }
        });
    })();
</script>
<link rel="stylesheet" href="/tailwindcss/output.css">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/@phosphor-icons/web@2.1.2/src/bold/style.css" />
<link rel="stylesheet" href="/style.css">
<!-- Fonts: Inter (UI), Vazirmatn (Persian/RTL), JetBrains Mono (code) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Vazirmatn:wght@400;500;600;700;800&family=JetBrains+Mono:ital,wght@0,400;0,500;0,600;1,400&display=swap" rel="stylesheet">
{% endblock %}""",
	r"template/error.html.twig": r"""{% extends 'template/base.html.twig' %}

{% block content %}
<!-- Main Content Area -->
<main id="main-content" class="flex-1 min-w-0 overflow-x-hidden order-2 xl:order-1 xl:mx-20 lg:mx-16 md:mx-8 sm:mx-4" role="main">
    <div class="flex flex-col xl:flex-row w-full relative">
    
        <!-- Content -->
        <div class="flex-1 w-full py-8 px-4 sm:py-12 sm:px-6 lg:px-8 xl:px-12">
            <div class="max-w-3xl mx-auto">
                <!-- Error Container -->
                <div class="flex flex-col items-center text-center space-y-8">
                    <!-- Error Status Code -->
                    <div class="space-y-2">
                        <h1 class="text-8xl sm:text-5xl font-bold text-gray-800 dark:text-gray-100">
                            {{ status }}
                        </h1>
                    </div>

                    <!-- Error Message -->
                    <div class="space-y-4">
                        <h2 class="text-2xl sm:text-3xl font-bold text-gray-800 dark:text-gray-100">
                            {{ $t('Oops! Something went wrong') }}
                        </h2>
                        <p class="text-lg text-gray-600 dark:text-gray-400 max-w-md mx-auto">
                            {{ $t('Page not found, please check the URL or return to the homepage.') }}
                        </p>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex flex-col sm:flex-row gap-4 pt-4">
                        <button onclick="history.back()" class="inline-flex items-center justify-center gap-2 px-8 py-3 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 font-semibold rounded-lg border-2 border-gray-300 dark:border-gray-600 hover:border-gray-400 dark:hover:border-gray-500 shadow-md hover:shadow-lg transition-all duration-200 transform hover:scale-105">
                            <i class="ph-bold {{ language.isRtl ? 'ph-arrow-right' : 'ph-arrow-left' }} text-xl"></i>
                            <span>{{ $t('Back') }}</span>
                        </button>
                        <a href="/" class="inline-flex items-center justify-center gap-2 px-8 py-3 bg-linear-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-semibold rounded-lg shadow-lg hover:shadow-xl transition-all duration-200 transform hover:scale-105">
                            <i class="ph-bold ph-house text-xl"></i>
                            <span>{{ $t('Home') }}</span>
                        </a>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="mt-40">
                    {% include 'template/footer.html.twig' %}
                </div>
            </div>
        </div>
    </div>
</main>
{% endblock %}

{% block rightSide %}
<!-- Action Buttons -->
<div class="space-y-2">
    <a href="{{ configs.repository }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-github-logo text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Star on GitHub') }}</span>
    </a>
    <a href="{{ configs.newissue }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-warning-circle text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Report Issue') }}</span>
    </a>
</div>
{% endblock %}""",
	r"template/page.html.twig": r"""{% extends 'template/base.html.twig' %}

{% block content %}
<!-- Main Content Area -->
<main id="main-content" class="flex-1 min-w-0 overflow-x-hidden order-2 xl:order-1 xl:mx-20 lg:mx-16 md:mx-8 sm:mx-4" role="main">
    <div class="flex flex-col xl:flex-row w-full relative">
        <!-- Content -->
        <div class="flex-1 w-full py-4 px-4 sm:py-8 sm:px-6 lg:px-8 xl:px-8 max-w-4xl mx-auto">
            <!-- Breadcrumb -->
            <nav class="flex items-center justify-between mb-6 text-sm overflow-x-auto" id="breadcrumb" aria-label="Breadcrumb">
                <ol class="flex items-center space-x-2 flex-nowrap">
                    <li class="whitespace-nowrap"><a href="/" class="text-blue-600 dark:text-secondary-400 hover:underline">{{ $t('Home') }}</a></li>
                    <li class="whitespace-nowrap" aria-hidden="true"><i class="ph-bold {{ language.isRtl ? 'ph-caret-left' : 'ph-caret-right' }} text-base text-gray-400"></i></li>
                    <li class="text-gray-600 dark:text-gray-400 whitespace-nowrap" aria-current="page">{% block title %}{{ title }}{% endblock %}</li>
                </ol>
            </nav>

            <!-- Document Content -->
            <article class="prose prose-sm sm:prose-base lg:prose-lg dark:prose-invert max-w-none overflow-x-auto doc-content">
                {% block html %}{{ content }}{% endblock %}
            </article>

            {% include 'template/footer.html.twig' %}
        </div>
    </div>
</main>
{% endblock %}

{% block rightSide %}
<!-- Action Buttons -->
<div>
    <a href="{{ configs.repository }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-github-logo text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Star on GitHub') }}</span>
    </a>
    <a href="{{ configs.newissue }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-warning-circle text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Report Issue') }}</span>
    </a>
</div>
{% endblock %}""",
	r"template/base.html.twig": r"""<!DOCTYPE html>
<html lang="{{ language.code }}" dir="{{ language.dir }}">
<head>
    {% include 'template/head.html.twig' %}
</head>
<body class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
    {% include 'template/navbar.html.twig' %}
    
    <!-- Quick scroll to top button -->
    <button id="scrollToTop" class="fixed h-10 w-10 bottom-6 end-6 z-40 hidden p-2 bg-blue-600 dark:bg-secondary-400 text-white dark:text-black rounded-full shadow-lg hover:bg-blue-700 dark:hover:bg-secondary-500 transition-all hover:scale-110" aria-label="Scroll to top">
        <i class="ph-bold ph-arrow-up text-lg"></i>
    </button>
    
    <!-- Main Container -->
    <div class="flex pt-16 justify-center">
        <div class="flex w-full max-w-[1600px]">
        
            <!-- Left Sidebar - Navigation Menu -->
            <aside id="leftSidebar" data-dir="{{ language.isRtl ? 'translate-x-full' : '-translate-x-full' }}" class="fixed bg-white dark:bg-gray-900 lg:bg-transparent dark:lg:bg-transparent lg:sticky top-16 start-0 h-[calc(100vh-4rem)] w-76 border-e border-gray-200 dark:border-gray-700 overflow-y-auto [scrollbar-width:thin] [scrollbar-color:transparent_transparent] hover:[scrollbar-color:var(--color-gray-300)_transparent] dark:hover:[scrollbar-color:var(--color-gray-600)_transparent] transform {{ language.isRtl ? 'translate-x-full' : '-translate-x-full' }} lg:translate-x-0 transition-transform duration-300 ease-in-out z-40 shrink-0">
                {% include 'template/sidebar.html.twig' %}
            </aside>

            <!-- Overlay for mobile -->
            <div id="overlay" class="hidden fixed inset-0 bg-black/50 z-30 lg:hidden"></div>

            {% block content %}{% endblock %}

            <!-- Right Sidebar - Table of Contents -->
            <aside class="sticky top-0 xl:top-16 xl:h-[calc(100vh-4rem)] xl:w-64 w-full overflow-y-auto px-4 py-6 xl:py-8 border-b xl:border-b-0 xl:border-s border-gray-200 dark:border-gray-700 order-1 xl:order-2 bg-white dark:bg-gray-900 hidden xl:block" role="complementary" aria-label="Table of contents">
                <div class="xl:sticky xl:top-0">
                    {% block rightSide %}{% endblock %}
                </div>
            </aside>
        </div>
    </div>
    {% include 'template/scripts.html.twig' %}
</body>
</html>""",
	r"template/hero.html.twig": r"""<!-- Hero Section -->
<div class="mb-12 relative overflow-hidden rounded-2xl border border-slate-200 dark:border-gray-800/60 bg-slate-50 dark:bg-gray-950">

    <!-- Galaxy canvas -->
    <canvas id="hero-galaxy" class="pointer-events-none absolute inset-0 w-full h-full"></canvas>

    <!-- Dot grid -->
    <div class="absolute inset-0 [background-image:radial-gradient(circle,#cbd5e1_1px,transparent_1px)] dark:[background-image:radial-gradient(circle,#1e293b_1px,transparent_1px)] [background-size:24px_24px]"></div>
    <!-- Vignette to fade dot edges -->
    <div class="absolute inset-0 bg-[radial-gradient(ellipse_90%_110%_at_50%_50%,transparent_55%,#f8fafc_100%)] dark:bg-[radial-gradient(ellipse_90%_110%_at_50%_50%,transparent_55%,#030712_100%)]"></div>

    <div class="relative z-10">

        <!-- ── Announcement strip ── -->
        <div class="border-b border-slate-200 dark:border-gray-800 bg-white/50 dark:bg-gray-900/50 backdrop-blur-sm px-4 py-2.5">
            <a href="{{ configs.pubDev }}" target="_blank" rel="noopener noreferrer"
               class="group flex items-center justify-center gap-2 text-sm text-slate-500 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors">
                <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-blue-100 dark:bg-blue-950 text-blue-700 dark:text-blue-400 text-xs font-bold tracking-wide">
                    <i class="ph-bold ph-confetti"></i> NEW
                </span>
                <span class="font-medium">v{{ finchVersion }} — {{ $t('Now Available on pub.dev') }}</span>
                <i class="ph-bold ph-arrow-{{ language.isRtl ? 'left' : 'right' }} text-xs transition-transform group-hover:translate-x-0.5"></i>
            </a>
        </div>

        <!-- ── Main two-column layout ── -->
        <div class="grid grid-cols-1 lg:grid-cols-2">

            <!-- Left: Brand & actions -->
            <div class="flex flex-col justify-center lg:ps-8 lg:pe-4 py-10 px-8 lg:py-14">

                <!-- Logo + name inline -->
                <div class="flex items-center gap-4 mb-5">
                    <div class="relative flex-shrink-0">
                        <div class="absolute inset-0 bg-blue-500/25 rounded-2xl blur-lg"></div>
                        <img src="/logo.svg" alt="Finch" class="relative h-14 w-14 drop-shadow-md" />
                    </div>
                    <div>
                        <h1 class="text-3xl font-bold tracking-tight text-slate-900 dark:text-white leading-none">{{ $t('Finch') }}</h1>
                        <span class="text-xs font-mono text-slate-400 dark:text-gray-500 mt-1 block">v{{ finchVersion }}</span>
                    </div>
                </div>

                <!-- Feature grid -->
                <div class="grid grid-cols-2 gap-x-6 gap-y-2.5 mb-8">
                    <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-gray-400">
                        <i class="ph-bold ph-lightning text-amber-500 flex-shrink-0"></i>{{ $t('Fast & Efficient') }}
                    </div>
                    <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-gray-400">
                        <i class="ph-bold ph-shield-check text-emerald-500 flex-shrink-0"></i>{{ $t('Type-Safe') }}
                    </div>
                    <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-gray-400">
                        <i class="ph-bold ph-puzzle-piece text-blue-500 flex-shrink-0"></i>{{ $t('Modular') }}
                    </div>
                    <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-gray-400">
                        <i class="ph-bold ph-rocket-launch text-violet-500 flex-shrink-0"></i>{{ $t('Production Ready') }}
                    </div>
                </div>

                <!-- CTA buttons -->
                <div class="flex flex-wrap gap-3">
                    <a href="#explore-docs" rel="noopener noreferrer"
                       class="inline-flex items-center gap-2 h-10 px-5 rounded-lg bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600 text-white text-sm font-semibold transition-colors shadow-sm shadow-blue-500/30">
                        <i class="ph-bold ph-book-open"></i>{{ $t('Get Started') }}
                    </a>
                    <a href="{{ configs.repository }}" target="_blank" rel="noopener noreferrer"
                       class="inline-flex items-center gap-2 h-10 px-5 rounded-lg border border-slate-200 dark:border-gray-700 bg-white dark:bg-gray-800/70 text-slate-700 dark:text-gray-300 text-sm font-medium hover:bg-slate-50 dark:hover:bg-gray-800 transition-colors">
                        <i class="ph-bold ph-github-logo"></i>{{ $t('GitHub') }}
                    </a>
                    <a href="{{ configs.demo }}" target="_blank" rel="noopener noreferrer"
                       class="inline-flex items-center gap-2 h-10 px-5 rounded-lg border border-slate-200 dark:border-gray-700 bg-white dark:bg-gray-800/70 text-slate-700 dark:text-gray-300 text-sm font-medium hover:bg-slate-50 dark:hover:bg-gray-800 transition-colors">
                        <i class="ph-bold ph-play-circle"></i>{{ $t('Demo') }}
                    </a>
                </div>
            </div>

            <!-- Right: Terminal window -->
            <div class="flex flex-col justify-center lg:ps-4 lg:pe-8 py-6 px-8 lg:py-14">
                <div class="rounded-xl overflow-hidden border border-slate-200 dark:border-gray-700 shadow-lg shadow-slate-200/60 dark:shadow-black/30">

                    <!-- Window chrome -->
                    <div class="flex items-center gap-1.5 px-4 py-3 bg-slate-100 dark:bg-gray-800 border-b border-slate-200 dark:border-gray-700">
                        <span class="w-3 h-3 rounded-full bg-red-400 dark:bg-red-500/70"></span>
                        <span class="w-3 h-3 rounded-full bg-yellow-400 dark:bg-yellow-500/70"></span>
                        <span class="w-3 h-3 rounded-full bg-green-400 dark:bg-green-500/70"></span>
                        <span class="ms-3 text-xs text-slate-400 dark:text-gray-500 font-mono">bash</span>
                        <button onclick="copyToClipboard('dart pub add finch')"
                                class="ms-auto inline-flex items-center gap-1 px-2 py-0.5 rounded bg-slate-200 dark:bg-gray-700 hover:bg-slate-300 dark:hover:bg-gray-600 text-slate-500 dark:text-gray-400 hover:text-slate-700 dark:hover:text-gray-200 text-xs transition-colors font-medium">
                            <i class="ph-bold ph-copy text-[10px]"></i>{{ $t('Copy') }}
                        </button>
                    </div>

                    <!-- Terminal body -->
                    <div dir="ltr" class="p-5 font-mono text-sm bg-white dark:bg-gray-900 space-y-1.5 select-text">
                        <div class="flex items-baseline gap-2">
                            <span class="text-blue-500 dark:text-blue-400">&#10095;</span>
                            <span class="text-slate-800 dark:text-gray-100">dart pub add finch</span>
                        </div>
                        <div class="text-slate-400 dark:text-gray-500 ps-5">Resolving dependencies...</div>
                        <div class="text-emerald-600 dark:text-emerald-400 ps-5">+ finch {{ finchVersion }}</div>
                        <div class="text-slate-400 dark:text-gray-500 ps-5">Changed 1 dependency!</div>
                        <div class="pt-1.5 flex items-baseline gap-2">
                            <span class="text-blue-500 dark:text-blue-400">&#10095;</span>
                            <span class="text-slate-800 dark:text-gray-100">dart run</span>
                        </div>
                        <div class="text-emerald-600 dark:text-emerald-400 ps-5">&#x1F426; Finch is listening on :8080</div>
                        <div class="ps-5 flex items-center gap-0.5 pt-0.5">
                            <span class="inline-block w-[7px] h-[14px] bg-slate-400 dark:bg-gray-400 rounded-[2px] animate-pulse"></span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        const btn = event.target.closest('button');
        const originalHTML = btn.innerHTML;
        btn.innerHTML = '<i class="ph-bold ph-check text-[10px]"></i> {{ $t("Copied!") }}';
        btn.classList.add('text-emerald-600', 'dark:text-emerald-400');
        setTimeout(() => {
            btn.innerHTML = originalHTML;
            btn.classList.remove('text-emerald-600', 'dark:text-emerald-400');
        }, 2000);
    });
}

(function () {
  var canvas = document.getElementById('hero-galaxy');
  if (!canvas) return;
  var ctx = canvas.getContext('2d');
  var stars = [], nebulas, raf;

  var NEBULAS = [
    { rx: 0.22, ry: 0.35, rad: 260, h: 224, s: 85 },
    { rx: 0.75, ry: 0.55, rad: 220, h: 265, s: 80 },
    { rx: 0.50, ry: 0.88, rad: 200, h: 195, s: 75 },
    { rx: 0.12, ry: 0.70, rad: 160, h: 180, s: 70 },
    { rx: 0.88, ry: 0.20, rad: 180, h: 305, s: 75 },
    { rx: 0.60, ry: 0.15, rad: 150, h: 245, s: 80 },
  ];

  function resize() {
    canvas.width  = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;
    initStars();
  }

  function initStars() {
    stars = [];
    var count = Math.floor(canvas.width * canvas.height / 900);
    for (var i = 0; i < count; i++) {
      var bright = Math.random() < 0.08; // 8% chance of a large bright star
      stars.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        r: bright ? (Math.random() * 1.8 + 1.4) : (Math.random() * 1.0 + 0.3),
        speed: Math.random() * 0.18 + 0.03,
        phase: Math.random() * Math.PI * 2,
        dPhase: Math.random() * 0.022 + 0.005,
        bright: bright,
      });
    }
  }

  function drawNebulas(w, h, dark) {
    for (var i = 0; i < NEBULAS.length; i++) {
      var nb = NEBULAS[i];
      var x = nb.rx * w, y = nb.ry * h;
      var alpha = dark ? 0.28 : 0.14;
      var g = ctx.createRadialGradient(x, y, 0, x, y, nb.rad);
      g.addColorStop(0,   'hsla(' + nb.h + ',' + nb.s + '%,62%,' + alpha + ')');
      g.addColorStop(0.4, 'hsla(' + nb.h + ',' + nb.s + '%,62%,' + (alpha * 0.5) + ')');
      g.addColorStop(1,   'hsla(' + nb.h + ',' + nb.s + '%,62%,0)');
      ctx.fillStyle = g;
      ctx.beginPath();
      ctx.arc(x, y, nb.rad, 0, 6.2832);
      ctx.fill();
    }
  }

  function draw() {
    var w = canvas.width, h = canvas.height;
    var dark = document.documentElement.classList.contains('dark');
    ctx.clearRect(0, 0, w, h);

    drawNebulas(w, h, dark);

    for (var j = 0; j < stars.length; j++) {
      var s = stars[j];
      s.phase += s.dPhase;
      var brightness = 0.4 + 0.6 * (0.5 + 0.5 * Math.sin(s.phase));
      var alpha = (dark ? 0.9 : 0.5) * brightness;
      if (s.bright && dark) {
        ctx.shadowBlur = 6;
        ctx.shadowColor = 'rgba(180,200,255,0.7)';
      }
      ctx.beginPath();
      ctx.arc(s.x, s.y, s.r, 0, 6.2832);
      ctx.fillStyle = dark
        ? 'rgba(220,232,255,' + alpha + ')'
        : 'rgba(51,65,85,'   + alpha + ')';
      ctx.fill();
      if (s.bright && dark) { ctx.shadowBlur = 0; }
      s.y -= s.speed;
      if (s.y < -2) { s.y = h + 2; s.x = Math.random() * w; }
    }

    raf = requestAnimationFrame(draw);
  }

  resize();
  draw();
  window.addEventListener('resize', function () { cancelAnimationFrame(raf); resize(); draw(); });
})();
</script>
""",
	r"template/document.html.twig": r"""{% extends 'template/base.html.twig' %}

{% block content %}
<!-- Main Content Area -->
<main id="main-content" class="flex-1 min-w-0 overflow-x-hidden order-2 xl:order-1 xl:mx-20 lg:mx-16 md:mx-8 sm:mx-4" role="main">
    <div class="flex flex-col xl:flex-row w-full relative">
    
        <!-- Content -->
        <div class="flex-1 w-full py-4 px-4 sm:py-8 sm:px-6 lg:px-8 xl:px-8 max-w-4xl mx-auto">
            <!-- Breadcrumb -->
            <nav class="flex items-center justify-between mb-6 text-sm overflow-x-auto" id="breadcrumb" aria-label="Breadcrumb">
                <ol class="flex items-center space-x-2 flex-nowrap">
                    <li class="whitespace-nowrap"><a href="/" class="text-blue-600 dark:text-secondary-400 hover:underline">{{ $t('Home') }}</a></li>
                    {% if meta.group %}
                        <li class="sm:inline-flex hidden whitespace-nowrap" aria-hidden="true"><i class="ph-bold {{ language.isRtl ? 'ph-caret-left' : 'ph-caret-right' }} text-base text-gray-400"></i></li>
                        <li class="sm:inline-flex hidden text-gray-600 dark:text-gray-400 whitespace-nowrap" aria-current="page">{{ meta.group }}</li>
                    {% endif %}
                    <li class="whitespace-nowrap" aria-hidden="true"><i class="ph-bold {{ language.isRtl ? 'ph-caret-left' : 'ph-caret-right' }} text-base text-gray-400"></i></li>
                    <li class="text-gray-600 dark:text-gray-400 whitespace-nowrap" aria-current="page">{{ title }}</li>
                </ol>
                <div class="flex items-center gap-2 ms-4">
                    <!-- Edit page -->
                    <a href="{{ configs.edit }}/{{ filename }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-2 px-3 py-1.5 rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors whitespace-nowrap">
                        <i class="ph-bold ph-pencil-simple text-base"></i>
                        <span class="text-xs hidden sm:inline">{{ $t('Edit') }}</span>
                    </a>
                </div>
            </nav>

            <!-- Mobile TOC -->
            <div class="xl:hidden mb-6 p-4 bg-linear-to-br from-gray-50 to-blue-50 dark:from-gray-800 dark:to-gray-700 rounded-lg border border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-2 mb-3">
                    <i class="ph-bold ph-list-bullets text-blue-600 dark:text-secondary-400"></i>
                    <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300 uppercase tracking-wide">{{ $t('On This Page') }}</h3>
                </div>
                <nav>
                    <ul class="flex flex-wrap gap-2">
                        {% for section in index %}
                            <li><a href="#{{ section.id }}" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs rounded-lg bg-white dark:bg-gray-700 hover:bg-blue-50 dark:hover:bg-gray-600 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 border border-gray-200 dark:border-gray-600 transition-colors">
                                <i class="ph-bold ph-hash text-xs"></i>
                                {{ section.title | html }}
                            </a></li>
                        {% endfor %}
                    </ul>
                </nav>
            </div>

            <!-- Document Content -->
            <article class="prose prose-sm sm:prose-base lg:prose-lg dark:prose-invert max-w-none overflow-x-auto doc-content">
                {{ content }}
            </article>

            <!-- Navigation Buttons -->
            <div class="flex flex-col sm:flex-row justify-between items-stretch sm:items-center gap-4 mt-12 pt-8 border-t-2 border-gray-200 dark:border-gray-700">
                {% if previous is defined %}
                    <a href="/{{ previous.key }}" class="flex-1 group flex items-center gap-3 px-5 py-4 rounded-xl border-2 bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-600 hover:border-blue-500 dark:hover:border-secondary-400 hover:bg-blue-50 dark:hover:bg-gray-700 transition-all hover:shadow-lg transform hover:-translate-y-0.5">
                        <i class="ph-bold {{ language.isRtl ? 'ph-arrow-right' : 'ph-arrow-left' }} text-2xl text-blue-600 dark:text-secondary-400 group-hover:scale-110 transition-transform"></i>
                        <div class="text-start min-w-0 flex-1">
                            <div class="text-xs text-gray-500 dark:text-gray-400 mb-1">{{ $t('Previous') }}</div>
                            <div class="font-semibold truncate text-gray-900 dark:text-white">{{ previous.title }}</div>
                            <div class="text-xs text-gray-600 dark:text-gray-400 mt-1">{{  $l.maxLength(previous.description, 50) }}</div>
                        </div>
                    </a>
                {% else %}
                    <div class="flex-1"></div>
                {% endif %}
                {% if next is defined %}
                    <a href="/{{ next.key }}" class="flex-1 group flex items-center gap-3 justify-end px-5 py-4 rounded-xl border-2 bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-600 hover:border-purple-500 dark:hover:border-purple-400 hover:bg-purple-50 dark:hover:bg-gray-700 transition-all hover:shadow-lg transform hover:-translate-y-0.5">
                        <div class="text-end min-w-0 flex-1">
                            <div class="text-xs text-gray-500 dark:text-gray-400 mb-1">{{ $t('Next') }}</div>
                            <div class="font-semibold truncate text-gray-900 dark:text-white">
                                {{ next.title }}
                            </div>
                            <div class="text-xs text-gray-600 dark:text-gray-400 mt-1">{{  $l.maxLength(next.description, 50) }}</div>
                        </div>
                        <i class="ph-bold {{ language.isRtl ? 'ph-arrow-left' : 'ph-arrow-right' }} text-2xl text-purple-600 dark:text-purple-400 group-hover:scale-110 transition-transform"></i>
                    </a>
                {% else %}
                    <div class="flex-1"></div>
                {% endif %}
            </div>

            {% include 'template/footer.html.twig' %}
        </div>
    </div>
</main>
{% endblock %}

{% block rightSide %}
<div class="flex items-center gap-2 mb-4">
    <i class="ph-bold ph-list-dashes text-blue-600 dark:text-secondary-400"></i>
    <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300 uppercase tracking-wide">{{ $t('On This Page') }}</h3>
</div>
<nav id="tableOfContents">
    <ul class="space-y-2">
        {% for section in index %}
            <li class="block">
                <a href="#{{ section.id }}" 
                    class="toc-link block px-3 py-1.5 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 border-s-2 border-transparent hover:border-blue-600 dark:hover:border-secondary-400 transition-all md-level-{{ section.level }}"
                    data-section="{{ section.id }}">
                    {{ section.title | html }}
                </a>
            </li>
        {% endfor %}
    </ul>
</nav>

<!-- Action Buttons -->
<div class="mt-6 space-y-2 pt-6 border-t border-gray-200 dark:border-gray-700">
    <a href="{{ configs.repository }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-github-logo text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Star on GitHub') }}</span>
    </a>
    <a href="{{ configs.newissue }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-warning-circle text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Report Issue') }}</span>
    </a>
    <a href="{{ configs.edit }}/{{ filename }}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors group">
        <i class="ph-bold ph-pencil-simple text-lg group-hover:scale-110 transition-transform"></i>
        <span class="text-sm">{{ $t('Edit this page') }}</span>
    </a>
</div>
{% endblock %}""",
	r"template/sidebar.html.twig": r"""<div class="p-4">
	<!-- Search filter for sidebar -->
	<div class="mb-3 ms-3">
		<div class="relative">
			<input 
				type="text" 
				id="sidebarSearch" 
				placeholder="{{ $t('Filter...') }}" 
				class="w-full px-3 py-1 ps-9 text-sm rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 focus:outline-none focus:ring-blue-500 dark:focus:ring-blue-400"
				autocomplete="off"
			>
			<i class="ph-bold ph-funnel-simple absolute start-3 top-1/2 transform -translate-y-1/2 text-base text-gray-400"></i>
		</div>
	</div>
	
	<style>
		details.menu-group summary .menu-chevron {
			transition: transform 0.2s ease;
			transform-origin: center 10px;
            margin-bottom: 5px;
		}
		details.menu-group[open] summary .menu-chevron {
			transform: rotate(90deg);
		}
		
		.sidebar-item-hidden {
			display: none !important;
		}
	</style>

	<!-- Getting Started -->
	<div class="mb-6">
		<div id="noSidebarResults" class="hidden p-4 text-center text-gray-500 dark:text-gray-400">
			{{ $t('No results found.') }}
		</div>
		<ul class="space-y-1">
			{% for menu in menus %}
				{% if menu.isGroup %}
					<li class="menu-group-item" data-search-text="{{ menu.title | lower }}">
                        {% for submenu in menu.children %}
                            {% if $e.isKey(submenu.key) %}
                                {{ $l.set('activeSubMenu', true) }}
                            {% endif %}
                        {% endfor %}
						<details class="menu-group" {{ $l.get('activeSubMenu') ? 'open' : '' }}>
							<summary class="flex items-center justify-between gap-2 px-3 py-2 font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg cursor-pointer list-none transition-colors">
								<span class="menu-item-text text-sm flex-1 leading-relaxed {{ $l.get('activeSubMenu') ? 'text-blue-600 dark:text-secondary-400' : '' }}">{{ menu.title }}</span>
							<span class="w-4 h-4 menu-chevron flex items-center justify-center">
									<i class="{{ $l.get('activeSubMenu') ? 'text-blue-600 dark:text-secondary-400' : '' }} ph-bold ph-caret-right text-xs"></i>
								</span>
							</summary>
							<ul class="mt-1 ms-4 space-y-1 border-s border-gray-200 dark:border-gray-700 ps-2">
								{% for submenu in menu.children %}
									<li class="submenu-item" data-search-text="{{ submenu.title | lower }}">
										<a href="{{ $l.urlLn(submenu.key) }}" class="{{ $e.isKey(submenu.key) ? 'bg-blue-50 dark:bg-gray-800 border-s-2 border-blue-500 dark:border-secondary-400 text-blue-600 dark:text-secondary-400 -ms-0.5' : 'border-s-2 border-transparent hover:border-gray-300 dark:hover:border-gray-600 -ms-0.5' }} flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
											{% if submenu.meta.icon %}
												<span class="menu-item-icon leading-none {{$e.isKey(submenu.key) ? 'text-blue-600 dark:text-secondary-400' : 'text-gray-500 dark:text-gray-400'}}">
													<i class="{{ submenu.meta.icon }} text-base"></i>
												</span>
											{% endif %}
											<span class="menu-item-text text-sm flex-1 leading-relaxed">{{ submenu.title }}</span>
										</a>
									</li>
								{% endfor %}
							</ul>
						</details>
					</li>
                    {{ $l.set('activeSubMenu', false) }}
				{% else %}
					<li class="menu-item" data-search-text="{{ menu.title | lower }}">
						<a href="{{ $l.urlLn(menu.key) }}" class="{{ $e.isKey(menu.key) ? 'bg-blue-50 dark:bg-gray-800 border-s-2 border-blue-500 dark:border-secondary-400 text-blue-600 dark:text-secondary-400 -ms-0.5' : 'border-s-2 border-transparent hover:border-gray-300 dark:hover:border-gray-600 -ms-0.5' }} flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
							{% if menu.meta.icon %}
								<span class="menu-item-icon leading-none {{$e.isKey(menu.key) ? 'text-blue-600 dark:text-secondary-400' : 'text-gray-500 dark:text-gray-400'}}">
									<i class="{{ menu.meta.icon }} text-base"></i>
								</span>
							{% endif %}
							<span class="menu-item-text text-sm flex-1 leading-relaxed">{{ menu.title }}</span>
						</a>
					</li>
				{% endif %}
			{% endfor %}
		</ul>
	</div>
</div>
""",
	r"template/scripts.html.twig": r"""<!-- Modern code blocks (Shiki syntax highlighting) -->
<script type="module" src="/code-blocks.js"></script>
<script src="/script.js"></script>
<script src="/app/includes.js" crossorigin="anonymous"></script>
{% if not isLocalDebug %}
<script type="speculationrules">
	{
        "prerender": [
            {
                "source": "document",
                "where": {
                    "and": [
                        {"href_matches": "/*"},
                        {"not": {"href_matches": "mailto:*"}},
                        {"not": {"href_matches": "tel:*"}},
                        {"not": {"href_matches": "javascript:*"}},
                        {"not": {"href_matches": "#*"}},
                        {"not": {"selector_matches": "a[target='_blank']"}},
                        {"not": {"selector_matches": "a[download]"}},
                        {"not": {"selector_matches": "a[rel~='external']"}},
                        {"not": {"selector_matches": "a[data-lang]"}}
                    ]
                },
                "eagerness": "moderate"
            }
        ]
    }
</script>
{% endif %}""",
	r"template/footer.html.twig": r"""<!-- Footer -->
<footer class="mt-16 bg-linear-to-b from-white to-gray-50 dark:from-gray-900 dark:to-gray-950 border-t-2 border-gray-200 dark:border-gray-700">
    <!-- Newsletter Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {# <div class="bg-linear-to-r from-blue-600 to-purple-600 dark:from-secondary-400 dark:to-purple-400 rounded-2xl p-8 mb-12">
            <div class="flex flex-col md:flex-row items-center justify-between gap-6">
                <div class="text-center md:text-left flex-1">
                    <h3 class="text-2xl font-bold text-white dark:text-black mb-2">{{ $t('Stay Updated!') }}</h3>
                    <p class="text-blue-100 dark:text-gray-800">{{ $t('Get the latest updates about Finch framework directly to your inbox.') }}</p>
                </div>
                <div class="flex-1 w-full max-w-md">
                    <form id="newsletterForm" class="flex gap-2">
                        <input 
                            type="email" 
                            placeholder="{{ $t('Enter your email') }}" 
                            class="flex-1 px-4 py-3 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-0 focus:ring-2 focus:ring-white dark:focus:ring-gray-600"
                            required
                        >
                        <button type="submit" class="px-6 py-3 bg-white dark:bg-gray-800 text-blue-600 dark:text-secondary-400 font-semibold rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors whitespace-nowrap">
                            {{ $t('Subscribe') }}
                        </button>
                    </form>
                </div>
            </div>
        </div> #}
        
        <!-- Footer Grid -->
        <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-4 gap-8 mb-12">
            <!-- Logo Column -->
            <div class="col-span-1 sm:col-span-1 lg:col-span-1">
                <div class="flex items-center space-x-3 mb-4">
                    <img src="/logo.svg" alt="Finch Logo" class="w-12 h-12"/>
                    <span class="text-2xl font-bold text-gray-900 dark:text-white">{{ $t('Finch') }}</span>
                </div>
                <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
                    {{ $t('A powerful Dart web framework for building modern applications.') }}
                </p>
                <!-- Social Icons -->
                <div class="flex items-center gap-3">
                    <a href="{{ configs.repository }}" target="_blank" rel="noopener" class="px-1 pt-0.5 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-blue-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-all" aria-label="GitHub">
                        <i class="ph-bold ph-github-logo text-xl"></i>
                    </a>
                    <a href="{{ configs.discord }}" target="_blank" rel="noopener" class="px-1 pt-0.5 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-blue-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-all" aria-label="Discord">
                        <i class="ph-bold ph-discord-logo text-xl"></i>
                    </a>
                    <a href="{{ configs.youtube }}" target="_blank" rel="noopener" class="px-1 pt-0.5 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-blue-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-all" aria-label="YouTube">
                        <i class="ph-bold ph-youtube-logo text-xl"></i>
                    </a>
                </div>
            </div>

            <!-- Resources Column -->
            <div>
                <h4 class="text-sm font-semibold text-gray-900 dark:text-white mb-4 uppercase tracking-wider flex items-center gap-2">
                    <i class="ph-bold ph-book-open text-blue-600 dark:text-secondary-400"></i>
                    {{ $t('Resources') }}
                </h4>
                <ul class="space-y-3">
                    <li><a href="/" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Getting Started') }}
                    </a></li>
                    <li><a href="{{ configs.otherPackages }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Packages') }}
                    </a></li>
                    <li><a href="{{ configs.demo }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Examples') }}
                    </a></li>
                    <li><a href="{{ configs.changelog }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Changelog') }}
                    </a></li>
                </ul>
            </div>

            <!-- Community Column -->
            <div>
                <h4 class="text-sm font-semibold text-gray-900 dark:text-white mb-4 uppercase tracking-wider flex items-center gap-2">
                    <i class="ph-bold ph-users text-purple-600 dark:text-purple-400"></i>
                    {{ $t('Community') }}
                </h4>
                <ul class="space-y-3">
                    <li><a href="{{ configs.community }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Forum') }}
                    </a></li>
                    <li><a href="{{ configs.discord }}" target="_blank" rel="noopener" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Discord') }}
                    </a></li>
                    <li><a href="{{ configs.contribution }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Contributing') }}
                    </a></li>
                    <li><a href="{{ configs.discussions }}" target="_blank" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Discussions') }}
                    </a></li>
                </ul>
            </div>

            <!-- Support Column -->
            <div>
                <h4 class="text-sm font-semibold text-gray-900 dark:text-white mb-4 uppercase tracking-wider flex items-center gap-2">
                    <i class="ph-bold ph-lifebuoy text-green-600 dark:text-green-400"></i>
                    {{ $t('Support') }}
                </h4>
                <ul class="space-y-3">
                    <li><a href="{{ configs.sponsor }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Sponsor') }}
                    </a></li>
                    <li><a href="{{ configs.repository }}/issues" target="_blank" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Report Bug') }}
                    </a></li>
                    <li><a href="{{ configs.support }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Get Help') }}
                    </a></li>
                    <li><a href="mailto:{{ configs.email }}" class="text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-2">
                        <i class="ph-bold ph-caret-right text-xs"></i>
                        {{ $t('Contact') }}
                    </a></li>
                </ul>
            </div>
        </div>

        <!-- Bottom Copyright Section -->
        <div class="pt-8 border-t border-gray-200 dark:border-gray-700">
            <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                <p class="text-sm text-gray-600 dark:text-gray-400">
                    © {{ $l.now() | dateFormat("yyyy") }} {{ $t('Finch Documentation. All rights reserved.') }}
                </p>
                <div class="flex items-center gap-4">
                    <div dir="ltr">
                        <a href="{{ configs.finchDoc }}" target="_blank" rel="noopener" 
                           class="inline-flex items-center space-x-2 px-4 py-2 bg-linear-to-r from-gray-100 to-gray-200 dark:from-gray-700 dark:to-gray-800 rounded-full text-gray-900 dark:text-white text-xs font-medium transition-all shadow-md hover:shadow-lg hover:scale-105">
                            <span>{{ $t('Built with') }}</span>
                            <img src="/finchdoc-logo.webp" alt="Finch Doc" class="w-6 h-6"/>
                            <span class="font-semibold">Finch Doc</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>""",
	r"template/pages/mcp-server.html.twig": r"""{% extends 'template/page.html.twig' %}

{% block html %}
	<!-- MCP Server Content -->
	<div class="not-prose space-y-5 pb-10">
		<div>
			<label class="flex items-center gap-2 text-[11px] font-bold tracking-wider text-gray-500 dark:text-gray-400">
				<i class="fa-solid fa-link text-teal-600 dark:text-teal-400"></i>
				{{ $t('Endpoint') }}
			</label>
			<div class="mt-5 items-stretch gap-2">
				<pre class="bg-gray-100 border-2 border-gray-300 dark:border-gray-700 dark:bg-gray-800 text-red-400 p-4 rounded mb-4 overflow-x-auto language-bash" dir="ltr" tabindex="0"><code class="language-bash">{{ $e.url('mcp') }}</code></pre>
			</div>
			<div class="mt-5 text-sm text-gray-500 dark:text-gray-400">
				<p>{{ $t('You can use this endpoint to access the MCP server for your project. Make sure to keep it secure and do not share it publicly.') }}</p>
				<p>{{ $t('For more information, refer to the documentation.') }}</p>
				<p>{{ $t('If you encounter any issues, please contact support.') }}</p>
			</div>
			<div>
				<pre class="bg-gray-100 border-2 border-gray-300 dark:border-gray-700 dark:bg-gray-800 text-red-400 p-4 rounded mb-4 overflow-x-auto language-json" dir="ltr" tabindex="0"><code class="language-json">{
    "mcpServers": {
        "mcp-finch-doc": {
            "url": "{{ $e.url('mcp') }}",
            "type": "sse"
        }
    }
}</code>
</pre>
			</div>
		</div>
	</div>
{% endblock %}

{% block title %}MCP Server{% endblock %}
""",
	r"template/pages/home.html.twig": r"""{% extends 'template/page.html.twig' %}

{% block content %}
<!-- Main Content Area -->
<main id="main-content" class="flex-1 min-w-0 overflow-x-hidden order-2 xl:order-1 xl:mx-20 lg:mx-16 md:mx-8 sm:mx-4" role="main">
    <div class="flex flex-col xl:flex-row w-full relative">
        <div class="flex-1 w-full py-4 px-4 sm:py-8 sm:px-6 lg:px-8 xl:px-8 max-w-4xl mx-auto">

            {% include 'template/hero.html.twig' %}

            {% set features = [
                {'icon': 'ph-bold ph-book-open', 'color': 'text-blue-600 dark:text-blue-400', 'bg': 'bg-blue-50 dark:bg-blue-950', 'title': 'API Docs with Swagger', 'desc': 'Rapid API development with auto-generated OpenAPI documentation.'},
                {'icon': 'ph-bold ph-broadcast', 'color': 'text-violet-600 dark:text-violet-400', 'bg': 'bg-violet-50 dark:bg-violet-950', 'title': 'Real-Time WebSockets', 'desc': 'Build live features with first-class WebSocket support.'},
                {'icon': 'ph-bold ph-database', 'color': 'text-emerald-600 dark:text-emerald-400', 'bg': 'bg-emerald-50 dark:bg-emerald-950', 'title': 'Multi-Database Support', 'desc': 'MongoDB, MySQL and SQLite integrations, ready out of the box.'},
                {'icon': 'ph-bold ph-clock-countdown', 'color': 'text-amber-600 dark:text-amber-400', 'bg': 'bg-amber-50 dark:bg-amber-950', 'title': 'Scheduled Tasks', 'desc': 'Run cron jobs directly from your Finch application.'},
                {'icon': 'ph-bold ph-translate', 'color': 'text-pink-600 dark:text-pink-400', 'bg': 'bg-pink-50 dark:bg-pink-950', 'title': 'Multi-Language & i18n', 'desc': 'Localization is built into routing, templates and content.'},
                {'icon': 'ph-bold ph-arrows-clockwise', 'color': 'text-teal-600 dark:text-teal-400', 'bg': 'bg-teal-50 dark:bg-teal-950', 'title': 'Database Migrations', 'desc': 'Manage schema changes with a built-in migration system.'}
            ] %}

            <!-- Why Finch -->
            <section class="mb-14">
                <div class="text-center mb-8 max-w-2xl mx-auto">
                    <h2 class="text-2xl sm:text-3xl font-bold text-gray-900 dark:text-white">{{ $t('Everything you need to ship a backend') }}</h2>
                    <p class="mt-3 text-gray-600 dark:text-gray-400">{{ $t('Finch bundles the pieces every Dart backend needs, so you can focus on your product instead of wiring plumbing.') }}</p>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                    {% for feature in features %}
                    <div class="p-5 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800/60 hover:shadow-lg hover:-translate-y-0.5 transition-all">
                        <div class="w-10 h-10 rounded-lg {{ feature.bg }} flex items-center justify-center mb-3">
                            <i class="{{ feature.icon }} {{ feature.color }} text-xl"></i>
                        </div>
                        <h3 class="font-semibold text-gray-900 dark:text-white mb-1">{{ $t(feature.title) }}</h3>
                        <p class="text-sm text-gray-600 dark:text-gray-400">{{ $t(feature.desc) }}</p>
                    </div>
                    {% endfor %}
                </div>
            </section>

            <!-- Explore the docs -->
            <section id="explore-docs" class="mb-14 scroll-mt-20">
                <div class="mb-6">
                    <h2 class="text-2xl sm:text-3xl font-bold text-gray-900 dark:text-white">{{ $t('Explore the documentation') }}</h2>
                    <p class="mt-3 text-gray-600 dark:text-gray-400">{{ $t('Jump straight into the topic you need.') }}</p>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {% for menu in menus %}
                        {% if menu.isGroup %}
                        <div class="p-5 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800/60 hover:border-blue-300 dark:hover:border-secondary-400 transition-colors">
                            <div class="flex items-center gap-3 mb-3">
                                <div class="w-10 h-10 shrink-0 rounded-lg bg-blue-50 dark:bg-gray-900 flex items-center justify-center">
                                    <i class="{{ menu.children[0].meta.icon ? menu.children[0].meta.icon : 'ph-bold ph-folder' }} text-blue-600 dark:text-secondary-400 text-xl"></i>
                                </div>
                                <h3 class="font-semibold text-gray-900 dark:text-white">{{ menu.title }}</h3>
                            </div>
                            <ul class="space-y-1.5">
                                {% for child in menu.children %}
                                    {% if child.key %}
                                    <li>
                                        <a href="{{ $l.urlLn(child.key) }}" class="group flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400 hover:text-blue-600 dark:hover:text-secondary-400 transition-colors">
                                            <i class="ph-bold ph-caret-right text-xs text-gray-400 group-hover:translate-x-0.5 transition-transform"></i>
                                            {{ child.title }}
                                        </a>
                                    </li>
                                    {% endif %}
                                {% endfor %}
                            </ul>
                        </div>
                        {% endif %}
                    {% endfor %}
                </div>
            </section>

            {% include 'template/footer.html.twig' %}
        </div>
    </div>
</main>
{% endblock %}

{% block title %}{{ $t('Home') }}{% endblock %}

{% block description %}{{ $t('Finch is a fast, modular and type-safe Dart web framework with built-in support for databases, WebSockets, auth, i18n and more.') }}{% endblock %}
"""
};