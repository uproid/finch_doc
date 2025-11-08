// Search functionality with AJAX
let searchTimeout;
let blurBackdrop = null;

// Create blur backdrop element
function createBlurBackdrop() {
    if (!blurBackdrop) {
        blurBackdrop = document.createElement('div');
        blurBackdrop.className = 'search-blur-backdrop';
        document.body.appendChild(blurBackdrop);
        
        // Close search when clicking backdrop
        blurBackdrop.addEventListener('click', () => {
            hideSearchResults();
        });
    }
    return blurBackdrop;
}

function showBlurBackdrop() {
    const backdrop = createBlurBackdrop();
    requestAnimationFrame(() => {
        backdrop.classList.add('active');
    });
}

function hideBlurBackdrop() {
    if (blurBackdrop) {
        blurBackdrop.classList.remove('active');
    }
}

function hideSearchResults() {
    searchResults.classList.add('hidden');
    hideBlurBackdrop();
}

async function performSearch(query, resultsContainer) {
    if (!query || query.length < 2) {
        resultsContainer.classList.add('hidden');
        if (resultsContainer === searchResults) {
            hideBlurBackdrop();
        }
        return;
    }

    // Clear previous timeout
    clearTimeout(searchTimeout);

    // Show loading state
    resultsContainer.innerHTML = `
        <div class="p-4 text-center text-gray-500 dark:text-gray-400">
            <div class="spinner-container">
                <div class="spinner"></div>
            </div>
        </div>
    `;
    resultsContainer.classList.remove('hidden');
    
    // Show blur backdrop for desktop search
    if (resultsContainer === searchResults) {
        showBlurBackdrop();
    }

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

searchInput.addEventListener('blur', (e) => {
    // Delay to allow clicking on search results
    setTimeout(() => {
        if (!searchResults.contains(document.activeElement)) {
            hideSearchResults();
        }
    }, 200);
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
        hideSearchResults();
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
        hideSearchResults();
        mobileSearchModal.classList.add('hidden');
    }
});

// Theme Toggle
document.addEventListener('DOMContentLoaded', function() {
    const themeToggle = document.getElementById('themeToggle');
    const html = document.documentElement;
    const themeIconLight = document.getElementById('theme-icon-light');
    const themeIconDark = document.getElementById('theme-icon-dark');

    function updatePrismTheme(isDark) {
        const prismLight = document.getElementById('prism-light');
        const prismDark = document.getElementById('prism-dark');
        
        if (isDark) {
            prismLight.disabled = true;
            prismDark.disabled = false;
        } else {
            prismLight.disabled = false;
            prismDark.disabled = true;
        }
    }

    function updateThemeIcons(isDark) {
        if (themeIconLight && themeIconDark) {
            if (isDark) {
                themeIconLight.style.display = 'none';
                themeIconDark.style.display = 'inline-block';
            } else {
                themeIconLight.style.display = 'inline-block';
                themeIconDark.style.display = 'none';
            }
        }
    }

    // Initialize Prism theme and icons on load
    const initialDarkMode = html.classList.contains('dark');
    updatePrismTheme(initialDarkMode);
    updateThemeIcons(initialDarkMode);

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            const isDark = html.classList.contains('dark');
            
            // Use requestAnimationFrame for smoother transitions in Safari
            requestAnimationFrame(() => {
                if (isDark) {
                    html.classList.remove('dark');
                    localStorage.setItem('theme', 'light');
                    updatePrismTheme(false);
                    updateThemeIcons(false);
                } else {
                    html.classList.add('dark');
                    localStorage.setItem('theme', 'dark');
                    updatePrismTheme(true);
                    updateThemeIcons(true);
                }
                
                // Force a repaint to ensure styles are updated
                void html.offsetHeight;
            });
        });
    }
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

// Add copy link button to all headers with md-header-tag class
function addHeaderCopyButtons() {
    const headers = document.querySelectorAll('.md-header-tag[id]');
    
    headers.forEach(header => {
        // Create a wrapper for the header content and button
        const headerId = header.getAttribute('id');
        if (!headerId) return;
        
        // Check if button already exists
        if (header.querySelector('.header-copy-link')) return;
        
        // Create the copy link button
        const copyButton = document.createElement('button');
        copyButton.className = 'header-copy-link inline-flex items-center justify-center ml-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200 text-gray-400 hover:text-blue-600 dark:hover:text-blue-400';
        copyButton.innerHTML = '<i class="fas fa-hashtag text-sm"></i>';
        copyButton.setAttribute('aria-label', 'Copy link to this section');
        copyButton.setAttribute('title', 'Copy link');
        
        // Add click handler
        copyButton.addEventListener('click', async (e) => {
            e.preventDefault();
            const url = window.location.origin + window.location.pathname + '#' + headerId;
            
            try {
                await navigator.clipboard.writeText(url);
                
                // Visual feedback
                const originalHTML = copyButton.innerHTML;
                copyButton.innerHTML = '<i class="fas fa-check text-sm"></i>';
                copyButton.classList.add('text-green-600', 'dark:text-green-400');
                
                setTimeout(() => {
                    copyButton.innerHTML = originalHTML;
                    copyButton.classList.remove('text-green-600', 'dark:text-green-400');
                }, 2000);
            } catch (err) {
                console.error('Failed to copy link:', err);
                // Fallback for older browsers
                const tempInput = document.createElement('input');
                tempInput.value = url;
                document.body.appendChild(tempInput);
                tempInput.select();
                document.execCommand('copy');
                document.body.removeChild(tempInput);
                
                // Visual feedback
                const originalHTML = copyButton.innerHTML;
                copyButton.innerHTML = '<i class="fas fa-check text-sm"></i>';
                copyButton.classList.add('text-green-600', 'dark:text-green-400');
                
                setTimeout(() => {
                    copyButton.innerHTML = originalHTML;
                    copyButton.classList.remove('text-green-600', 'dark:text-green-400');
                }, 2000);
            }
        });
        
        // Make the header a group for hover effect
        header.classList.add('group', 'relative');
        
        // Append the button to the header
        header.appendChild(copyButton);
    });
}

// Initialize header copy buttons when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', addHeaderCopyButtons);
} else {
    addHeaderCopyButtons();
}