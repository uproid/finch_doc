// Disable browser's automatic scroll restoration
if ('scrollRestoration' in history) {
    history.scrollRestoration = 'manual';
}

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
                    <p>${ DS.tr('Error performing search. Please try again.') }</p>
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
                <p>${ DS.tr('No results found for') } "${searchTerm}"</p>
            </div>
        `;
        container.classList.remove('hidden');
        return;
    }

    let html = '<div class="p-2">';
    html += `<div class="px-3 py-2 text-xs font-semibold text-gray-500 dark:text-gray-400">${ DS.trParam("Found {count} results", { count: data.count }) }</div>`;
    
    data.data.forEach(item => {
        let icon = '';
        if(item.meta && item.meta.icon) {
            icon = `<i class="${item.meta.icon} text-blue-600 dark:text-blue-400 mt-1"></i>`
        }
        let group = '';
        if(item.meta && item.meta.group) {
            group = `<i class="text-xs text-gray-500 dark:text-gray-400">${item.meta.group}</i>`;
        }
        html += `
            <a href="/${item.key}" class="block px-3 py-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                <div class="flex items-start gap-3">
                    ${icon}
                    <div class="flex-1 min-w-0">
                        <div class="font-semibold text-gray-900 dark:text-gray-100">${highlightMatch(item.title, searchTerm)}</div>
                        ${group}
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
    var dir = leftSidebar.attributes['data-dir'].value;
    leftSidebar.classList.toggle(dir);
    overlay.classList.toggle('hidden');
});

overlay.addEventListener('click', () => {
    var dir = leftSidebar.attributes['data-dir'].value;
    leftSidebar.classList.add(dir);
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

// Language Dropdown
const languageDropdown = document.getElementById('languageDropdown');
const languageMenu = document.getElementById('languageMenu');

if (languageDropdown && languageMenu) {
    languageDropdown.addEventListener('click', (e) => {
        e.stopPropagation();
        languageMenu.classList.toggle('hidden');
        // Close tools menu if open
        if (toolsMenu) {
            toolsMenu.classList.add('hidden');
        }
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!languageDropdown.contains(e.target) && !languageMenu.contains(e.target)) {
            languageMenu.classList.add('hidden');
        }
    });

    // Close dropdown on ESC key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            languageMenu.classList.add('hidden');
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
        copyButton.className = 'header-copy-link inline-flex items-center justify-center ms-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200 text-gray-400 hover:text-blue-600 dark:hover:text-blue-400';
        copyButton.innerHTML = '<i class="ph-bold ph-copy text-sm"></i>';
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
                copyButton.innerHTML = '<i class="ph-bold ph-check text-sm"></i>';
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
                copyButton.innerHTML = '<i class="ph-bold ph-check text-sm"></i>';
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

// ============================================
// MODERN ENHANCEMENTS
// ============================================

// Reading Progress Bar (in navbar)
function updateReadingProgress() {
    const article = document.querySelector('.doc-content');
    if (!article) return;
    
    const progressBar = document.getElementById('readingProgress');
    if (!progressBar) return;
    
    const windowHeight = window.innerHeight;
    const articleTop = article.offsetTop;
    const articleHeight = article.offsetHeight;
    const scrolled = window.scrollY - articleTop + windowHeight;
    const progress = Math.min(100, Math.max(0, (scrolled / articleHeight) * 100));
    
    progressBar.style.width = `${progress}%`;
}

window.addEventListener('scroll', updateReadingProgress);
window.addEventListener('resize', updateReadingProgress);
document.addEventListener('DOMContentLoaded', updateReadingProgress);

// Scroll to Top Button
const scrollToTopBtn = document.getElementById('scrollToTop');
if (scrollToTopBtn) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            scrollToTopBtn.classList.remove('hidden');
        } else {
            scrollToTopBtn.classList.add('hidden');
        }
    });
    
    scrollToTopBtn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

// TOC Active Link Highlighting
const tocLinks = document.querySelectorAll('.toc-link');
const sections = Array.from(tocLinks).map(link => {
    const id = link.getAttribute('href').substring(1);
    return document.getElementById(id);
}).filter(Boolean);

function updateActiveTocLink() {
    let currentSection = null;
    const scrollPosition = window.scrollY + 100;
    
    for (const section of sections) {
        if (section.offsetTop <= scrollPosition) {
            currentSection = section;
        }
    }
    
    tocLinks.forEach(link => {
        link.classList.remove('!border-blue-600', 'dark:!border-secondary-400', '!text-blue-600', 'dark:!text-secondary-400', 'bg-blue-50', 'dark:bg-gray-800', 'font-semibold');
    });
    
    if (currentSection) {
        const activeLink = document.querySelector(`.toc-link[href="#${currentSection.id}"]`);
        if (activeLink) {
            activeLink.classList.add('!border-blue-600', 'dark:!border-secondary-400', '!text-blue-600', 'dark:!text-secondary-400', 'bg-blue-50', 'dark:bg-gray-800', 'font-semibold');
        }
    }
}

window.addEventListener('scroll', updateActiveTocLink);
document.addEventListener('DOMContentLoaded', updateActiveTocLink);

// Copy Page Link
const copyPageLinkBtn = document.getElementById('copyPageLink');
if (copyPageLinkBtn) {
    copyPageLinkBtn.addEventListener('click', async () => {
        const url = window.location.href;
        try {
            await navigator.clipboard.writeText(url);
            const icon = copyPageLinkBtn.querySelector('i');
            const originalClass = icon.className;
            icon.className = 'ph-bold ph-check text-base';
            copyPageLinkBtn.classList.add('!text-green-600', 'dark:!text-green-400', '!border-green-500');
            
            setTimeout(() => {
                icon.className = originalClass;
                copyPageLinkBtn.classList.remove('!text-green-600', 'dark:!text-green-400', '!border-green-500');
            }, 2000);
        } catch (err) {
            console.error('Failed to copy:', err);
        }
    });
}

// Sidebar Search Filter
const sidebarSearch = document.getElementById('sidebarSearch');
if (sidebarSearch) {
    sidebarSearch.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const menuItems = document.querySelectorAll('.menu-item, .submenu-item');
        
        menuItems.forEach(item => {
            const text = item.getAttribute('data-search-text') || '';
            if (text.includes(query)) {
                item.classList.remove('sidebar-item-hidden');
            } else {
                item.classList.add('sidebar-item-hidden');
            }
        });

        // Hidden groups if no items match
        document.querySelectorAll('.menu-group').forEach(group => {
            const visibleItems = group.querySelectorAll('.menu-item:not(.sidebar-item-hidden), .submenu-item:not(.sidebar-item-hidden)');
            if (visibleItems.length === 0) {
                group.classList.add('sidebar-item-hidden');
            } else {
                group.classList.remove('sidebar-item-hidden');
            }
        });

        // Open all groups if searching
        if (query.length > 0) {
            document.querySelectorAll('.menu-group').forEach(group => {
                group.setAttribute('open', '');
            });
        }
    });
}

// Newsletter Form
const newsletterForm = document.getElementById('newsletterForm');
if (newsletterForm) {
    newsletterForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const email = e.target.querySelector('input[type="email"]').value;
        
        // Show success message
        const submitBtn = e.target.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = DS.tr('Subscribed!');
        submitBtn.classList.add('bg-green-500', 'text-white');
        
        setTimeout(() => {
            submitBtn.textContent = originalText;
            submitBtn.classList.remove('bg-green-500', 'text-white');
            e.target.reset();
        }, 3000);
        
        // Here you would normally send to your backend
        console.log('Newsletter subscription:', email);
    });
}

// Performance: Lazy load images
document.addEventListener('DOMContentLoaded', () => {
    const images = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                imageObserver.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));
});

console.log('✨ Finch Documentation - Enhanced & Ready!');