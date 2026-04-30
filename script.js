// Language toggle functionality
let currentLang = 'en';

const langToggle = document.getElementById('lang-toggle');
const translatableElements = document.querySelectorAll('[data-en]');

langToggle.addEventListener('click', () => {
    currentLang = currentLang === 'en' ? 'pt' : 'en';
    langToggle.textContent = currentLang === 'en' ? 'PT' : 'EN';
    updateLanguage();
});

function updateLanguage() {
    translatableElements.forEach(element => {
        const text = element.getAttribute(`data-${currentLang}`);
        if (text) {
            // Check if element has child elements (like the social-btn spans)
            if (element.children.length > 0 && element.tagName !== 'A') {
                // For elements with children, update text content carefully
                element.childNodes.forEach(node => {
                    if (node.nodeType === Node.TEXT_NODE && node.textContent.trim()) {
                        node.textContent = text;
                    }
                });
            } else {
                element.textContent = text;
            }
        }
    });
    
    // Update HTML lang attribute
    document.documentElement.lang = currentLang;
    
    // Save preference to localStorage
    localStorage.setItem('preferredLanguage', currentLang);
}

// Load saved language preference on page load
document.addEventListener('DOMContentLoaded', () => {
    const savedLang = localStorage.getItem('preferredLanguage');
    if (savedLang && (savedLang === 'en' || savedLang === 'pt')) {
        currentLang = savedLang;
        langToggle.textContent = currentLang === 'en' ? 'PT' : 'EN';
        updateLanguage();
    }
});

// Add smooth scroll behavior for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add intersection observer for fade-in animations on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all glass cards
document.querySelectorAll('.glass-card, .glass-footer').forEach(card => {
    card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(card);
});

// Add hover effect enhancement for game cards
document.querySelectorAll('.game-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.zIndex = '10';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.zIndex = '1';
    });
});

// Add parallax effect to background
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const bgGradient = document.querySelector('.bg-gradient');
    if (bgGradient) {
        bgGradient.style.transform = `translateY(${scrolled * 0.3}px)`;
    }
});

// Add typing effect to hero subtitle (optional enhancement)
const subtitle = document.querySelector('.hero .subtitle');
if (subtitle) {
    const originalText = subtitle.textContent;
    subtitle.textContent = '';
    let charIndex = 0;
    
    function typeWriter() {
        if (charIndex < originalText.length) {
            subtitle.textContent += originalText.charAt(charIndex);
            charIndex++;
            setTimeout(typeWriter, 50);
        }
    }
    
    // Start typing effect after a short delay
    setTimeout(typeWriter, 1000);
}

// Add dynamic gradient animation speed based on mouse movement
document.addEventListener('mousemove', (e) => {
    const body = document.body;
    const x = e.clientX / window.innerWidth;
    const y = e.clientY / window.innerHeight;
    
    body.style.backgroundPosition = `${x * 100}% ${y * 100}%`;
});

// Console message for developers
console.log('%c👋 Hello Developer!', 'color: #c2ff02; font-size: 20px; font-weight: bold;');
console.log('%cInterested in José Pilas\' work? Check out his GitHub and Instagram!', 'color: #94dfe6; font-size: 14px;');
console.log('%cColors used: #cd5d19, #94dfe6, #c2ff02, #ff0900', 'color: #cd5d19; font-size: 12px;');
