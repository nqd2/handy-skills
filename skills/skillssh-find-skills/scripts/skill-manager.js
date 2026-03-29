const { chromium } = require('playwright');

/**
 * Searches for skills on skills.sh
 * @param {string} query - The search query
 * @param {number} limit - The number of results to return (default: 50)
 * @returns {Promise<Array>} - Array of skill objects matching the search.json format
 */
async function searchSkills(query, limit = 50) {
    const url = `https://skills.sh/api/search?q=${encodeURIComponent(query)}&limit=${limit}`;
    try {
        const response = await fetch(url);
        const data = await response.json();
        // Handle varying API response wrappers
        return data.skills || data.results || data; 
    } catch (error) {
        console.error("Error fetching skills:", error);
        return [];
    }
}

/**
 * Uses Playwright to scrape the installation command for a specific skill
 * @param {string} skillId - The ID of the skill (e.g., 'vercel-labs/agent-skills/web-design-guidelines')
 * @returns {Promise<string|null>} - The npx installation command
 */
async function getInstallCommand(skillId) {
    let browser;
    try {
        browser = await chromium.launch({ headless: true });
        const page = await browser.newPage();
        
        await page.goto(`https://skills.sh/${skillId}`, { waitUntil: 'domcontentloaded' });
        
        const installCommand = await page.evaluate(() => {
            const codeElements = Array.from(document.querySelectorAll('code.truncate'));
            
            for (const el of codeElements) {
                const text = el.innerText || el.textContent;
                if (text && text.includes('npx skills add')) {
                    // Extract the command and clean up span/comments
                    return text.replace(/^\$\s*/, '').replace(/<!--.*?-->/g, '').trim();
                }
            }
            return null;
        });
        
        return installCommand;
    } catch (error) {
        console.error(`Error scraping command for ${skillId}:`, error);
        return null;
    } finally {
        if (browser) {
            await browser.close();
        }
    }
}

// Allow execution directly from the AI Agent's terminal
if (require.main === module) {
    const args = process.argv.slice(2);
    const action = args[0];

    if (action === 'search') {
        const query = args[1];
        const limit = parseInt(args[2]) || 50;
        searchSkills(query, limit).then(res => console.log(JSON.stringify(res, null, 2)));
    } else if (action === 'get-command') {
        const skillId = args[1];
        getInstallCommand(skillId).then(cmd => console.log(cmd));
    } else {
        console.log("Usage: node skill-manager.js [search <query> <limit>] | [get-command <skillId>]");
    }
}

module.exports = { searchSkills, getInstallCommand };
