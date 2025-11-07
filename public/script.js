// Search functionality with AJAX
let searchTimeout;

async function performSearch(query, resultsContainer) {
    if (!query || query.length < 2) {
        resultsContainer.classList.add('hidden');
        return;
    }

    // Clear previous timeout
    clearTimeout(searchTimeout);

    // Show loading state
    resultsContainer.innerHTML = `
        <div class="p-4 text-center text-gray-500 dark:text-gray-400">
            <i class="fas fa-spinner fa-spin text-2xl mb-2"></i>
            <p>Searching...</p>
        </div>
    `;
    resultsContainer.classList.remove('hidden');

    // Debounce search requests
    searchTimeout = setTimeout(async () => {
        try {
            const response = await fetch(`/api/search/?q=${encodeURIComponent(query)}`);
            
            if (!response.ok) {
                throw new Error('Search request failed');
            }

            const data = await response.json();
            displayResults(data, resultsContainer, query);
        } catch (error) {
            console.error('Search error:', error);
            resultsContainer.innerHTML = `
                <div class="p-4 text-center text-red-500 dark:text-red-400">
                    <i class="fas fa-exclamation-triangle text-2xl mb-2"></i>
                    <p>Error performing search. Please try again.</p>
                </div>
            `;
        }
    }, 300);
}

function displayResults(data, container, searchTerm) {
    if (!data.data || data.count === 0) {
        container.innerHTML = `
            <div class="p-4 text-center text-gray-500 dark:text-gray-400">
                <i class="fas fa-search text-3xl mb-2"></i>
                <p>No results found for "${searchTerm}"</p>
            </div>
        `;
        container.classList.remove('hidden');
        return;
    }

    let html = '<div class="p-2">';
    html += `<div class="px-3 py-2 text-xs font-semibold text-gray-500 dark:text-gray-400">Found ${data.count} result${data.count !== 1 ? 's' : ''}</div>`;
    
    data.data.forEach(item => {
        html += `
            <a href="/${item.key}" class="block px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                <div class="flex items-start gap-3">
                    <i class="fas fa-file-alt text-blue-600 dark:text-blue-400 mt-1"></i>
                    <div class="flex-1 min-w-0">
                        <div class="font-semibold text-gray-900 dark:text-gray-100">${highlightMatch(item.title, searchTerm)}</div>
                        <div class="text-xs text-gray-500 dark:text-gray-400 mt-1">${item.description}</div>
                    </div>
                </div>
            </a>
        `;
    });
    
    html += '</div>';
    container.innerHTML = html;
    container.classList.remove('hidden');
}

function highlightMatch(text, searchTerm) {
    const regex = new RegExp(`(${searchTerm})`, 'gi');
    return text.replace(regex, '<mark class="bg-yellow-200 dark:bg-yellow-600 px-1 rounded">$1</mark>');
}

// Desktop Search
const searchInput = document.getElementById('searchInput');
const searchResults = document.getElementById('searchResults');

searchInput.addEventListener('input', (e) => {
    performSearch(e.target.value, searchResults);
});

searchInput.addEventListener('focus', (e) => {
    if (e.target.value.length >= 2) {
        performSearch(e.target.value, searchResults);
    }
});

// Mobile Search
const mobileSearchToggle = document.getElementById('mobileSearchToggle');
const mobileSearchModal = document.getElementById('mobileSearchModal');
const mobileSearchInput = document.getElementById('mobileSearchInput');
const mobileSearchResults = document.getElementById('mobileSearchResults');
const closeMobileSearch = document.getElementById('closeMobileSearch');

mobileSearchToggle.addEventListener('click', () => {
    mobileSearchModal.classList.remove('hidden');
    mobileSearchInput.focus();
});

closeMobileSearch.addEventListener('click', () => {
    mobileSearchModal.classList.add('hidden');
    mobileSearchInput.value = '';
    mobileSearchResults.innerHTML = '';
});

mobileSearchInput.addEventListener('input', (e) => {
    performSearch(e.target.value, mobileSearchResults);
});

// Close search results when clicking outside
document.addEventListener('click', (e) => {
    if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
        searchResults.classList.add('hidden');
    }
});

// Keyboard shortcut for search (Ctrl+K)
document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        searchInput.focus();
    }
    
    // ESC to close search
    if (e.key === 'Escape') {
        searchResults.classList.add('hidden');
        mobileSearchModal.classList.add('hidden');
    }
});

// Theme Toggle
const themeToggle = document.getElementById('themeToggle');
const html = document.documentElement;

themeToggle.addEventListener('click', () => {
    const isDark = html.classList.contains('dark');
    
    if (isDark) {
        html.classList.remove('dark');
        localStorage.setItem('theme', 'light');
    } else {
        html.classList.add('dark');
        localStorage.setItem('theme', 'dark');
    }
    
    // Force a repaint to ensure styles are updated
    void html.offsetHeight;
});

// Mobile Menu Toggle
const menuToggle = document.getElementById('menuToggle');
const leftSidebar = document.getElementById('leftSidebar');
const overlay = document.getElementById('overlay');

menuToggle.addEventListener('click', () => {
    leftSidebar.classList.toggle('-translate-x-full');
    overlay.classList.toggle('hidden');
});

overlay.addEventListener('click', () => {
    leftSidebar.classList.add('-translate-x-full');
    overlay.classList.add('hidden');
});

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});

// Auto-generate table of contents (optional)
function generateTOC() {
    const article = document.querySelector('article');
    const headings = article.querySelectorAll('h2, h3');
    const toc = document.getElementById('tableOfContents').querySelector('ul');
}

// Scroll spy for table of contents
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        const id = entry.target.getAttribute('id');
        if (!id) return;
        
        const tocLink = document.querySelector(`#tableOfContents a[href="#${id}"]`);
        if (tocLink) {
            if (entry.isIntersecting) {
                // Remove active class from all links
                document.querySelectorAll('#tableOfContents a').forEach(link => {
                    link.classList.remove('toc-active', 'text-blue-600', 'dark:text-blue-400', 'border-blue-600', 'bg-gray-100', 'dark:bg-gray-700');
                });
                // Add active class to current link
                tocLink.classList.add('toc-active');
            }
        }
    });
}, { 
    rootMargin: '-80px 0px -80%',
    threshold: 0.1
});

// Observe all headings with IDs
document.querySelectorAll('article h1[id], article h2[id], article h3[id], article h4[id], article h5[id], article h6[id]').forEach((heading) => {
    observer.observe(heading);
});

// Tools Dropdown
const toolsDropdown = document.getElementById('toolsDropdown');
const toolsMenu = document.getElementById('toolsMenu');

if (toolsDropdown && toolsMenu) {
    toolsDropdown.addEventListener('click', (e) => {
        e.stopPropagation();
        toolsMenu.classList.toggle('hidden');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!toolsDropdown.contains(e.target) && !toolsMenu.contains(e.target)) {
            toolsMenu.classList.add('hidden');
        }
    });

    // Close dropdown on ESC key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            toolsMenu.classList.add('hidden');
        }
    });
}