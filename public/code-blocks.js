/* Modern code blocks
 * 1. Instantly wraps every <pre><code> in an editor-style frame
 *    (header with traffic dots, language badge, copy button).
 * 2. Asynchronously highlights the code with Shiki (VS Code grammars),
 *    rendering both light & dark themes via CSS variables.
 * If the CDN is unreachable the frame still works, just without colors.
 */

const SHIKI_CDN = 'https://esm.sh/shiki@3';
const THEMES = { light: 'github-light', dark: 'one-dark-pro' };
const COLLAPSE_PX = 520; // blocks taller than this get collapsed

const LANG_LABELS = {
    js: 'JavaScript', ts: 'TypeScript', json: 'JSON', yaml: 'YAML',
    yml: 'YAML', html: 'HTML', css: 'CSS', sql: 'SQL', bash: 'Bash',
    shell: 'Shell', sh: 'Shell', zsh: 'Shell', dart: 'Dart',
    docker: 'Dockerfile', dockerfile: 'Dockerfile', nginx: 'Nginx',
    jinja: 'Jinja', twig: 'Twig', xml: 'XML', md: 'Markdown',
    markdown: 'Markdown', py: 'Python', python: 'Python',
};

function detectLang(pre, code) {
    const m = (code.className + ' ' + pre.className).match(/language-([\w+-]+)/i);
    return m ? m[1].toLowerCase() : '';
}

function buildFrame(pre, code) {
    const lang = detectLang(pre, code);
    const raw = code.textContent.replace(/\n+$/, '');

    const frame = document.createElement('figure');
    frame.className = 'code-frame not-prose';
    frame.setAttribute('dir', 'ltr');

    const header = document.createElement('figcaption');
    header.className = 'code-frame-header';

    const dots = document.createElement('span');
    dots.className = 'code-frame-dots';
    dots.setAttribute('aria-hidden', 'true');
    dots.innerHTML = '<i></i><i></i><i></i>';

    const langEl = document.createElement('span');
    langEl.className = 'code-frame-lang';
    langEl.textContent = LANG_LABELS[lang] || (lang ? lang.toUpperCase() : 'CODE');

    const copyBtn = document.createElement('button');
    copyBtn.type = 'button';
    copyBtn.className = 'code-frame-copy';
    copyBtn.setAttribute('aria-label', 'Copy code');
    copyBtn.innerHTML = '<i class="ph-bold ph-copy"></i><span>Copy</span>';
    copyBtn.addEventListener('click', async () => {
        try {
            await navigator.clipboard.writeText(raw);
        } catch {
            const ta = document.createElement('textarea');
            ta.value = raw;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            ta.remove();
        }
        copyBtn.classList.add('copied');
        copyBtn.innerHTML = '<i class="ph-bold ph-check"></i><span>Copied!</span>';
        setTimeout(() => {
            copyBtn.classList.remove('copied');
            copyBtn.innerHTML = '<i class="ph-bold ph-copy"></i><span>Copy</span>';
        }, 2000);
    });

    header.append(dots, langEl, copyBtn);

    const body = document.createElement('div');
    body.className = 'code-frame-body';

    pre.replaceWith(frame);
    body.appendChild(pre);
    frame.append(header, body);

    return { frame, body, pre, lang, raw };
}

function applyCollapse(entry) {
    const pre = entry.body.querySelector('pre');
    if (!pre || entry.body.classList.contains('is-collapsed')) return;
    if (pre.scrollHeight <= COLLAPSE_PX) return;

    entry.body.classList.add('is-collapsed');
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'code-frame-expand';
    btn.innerHTML = '<i class="ph-bold ph-caret-down"></i><span>Show more</span>';
    btn.addEventListener('click', () => {
        entry.body.classList.remove('is-collapsed');
        btn.remove();
    });
    entry.body.appendChild(btn);
}

async function highlightAll(entries) {
    let codeToHtml;
    try {
        ({ codeToHtml } = await import(SHIKI_CDN));
    } catch {
        return; // offline / CDN blocked — plain frames still work
    }

    for (const entry of entries) {
        if (!entry.lang) continue;
        try {
            const html = await codeToHtml(entry.raw, {
                lang: entry.lang,
                themes: THEMES,
                defaultColor: 'light',
            });
            const tpl = document.createElement('template');
            tpl.innerHTML = html;
            const newPre = tpl.content.firstElementChild;
            if (newPre) {
                newPre.tabIndex = 0;
                const old = entry.body.querySelector('pre');
                if (old) old.replaceWith(newPre);
            }
        } catch {
            /* unknown language — keep plain text */
        }
        applyCollapse(entry);
    }
}

function init() {
    const entries = [];
    document.querySelectorAll('pre > code').forEach((code) => {
        const pre = code.parentElement;
        if (pre.closest('.code-frame')) return;
        entries.push(buildFrame(pre, code));
    });
    entries.forEach(applyCollapse);
    if (entries.length) highlightAll(entries);
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}
