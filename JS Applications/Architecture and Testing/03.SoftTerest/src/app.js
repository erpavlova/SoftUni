import { setupHome } from '../views/home.js';
import { setupLogin } from '../views/login.js';
import { setupRegister } from '../views/register.js';
import { setupDashboard } from '../views/dashboard.js';
import { setupDetails } from '../views/details.js';
import { setupCreate } from '../views/create.js';

// setup views
// setup nav links
// show appropriate nabvigation based on user session
// start application in default view -> home

const main = document.querySelector('main');
const nav = document.querySelector('nav');

const views = {};
const links = {};

const navigation = {
    goTo,
    setUserNav
};

registerView('home', document.getElementById('home-page'), setupHome, 'homeLink');
registerView('login', document.getElementById('login-page'), setupLogin, 'loginLink');
registerView('register', document.getElementById('register-page'), setupRegister, 'registerLink');
registerView('dashboard', document.getElementById('dashboard-holder'), setupDashboard, 'dashboardLink');
registerView('create', document.getElementById('create-page'), setupCreate, 'createLink');
registerView('details', document.getElementById('details-page'), setupDetails);

document.getElementById('views').remove();


setupNavigation();

// start application in home view
goTo('home');

function registerView(name, section, setup, linkId) {
    const view = setup(section, navigation);
    views[name] = view;

    if (linkId) {
        links[linkId] = name;
    }
}

async function goTo(name, ...params) {
    main.innerHTML = '';
    const view = views[name];
    const section = await view(...params);
    //console.log(section);
    main.appendChild(section)
}

function setupNavigation() {
    setUserNav();

    nav.addEventListener('click', (ev) => {
        const viewName = links[ev.target.id];
        if (viewName) {
            ev.preventDefault();
            goTo(viewName);
        }
    })
}

function setUserNav() {
    const token = sessionStorage.getItem('authToken');
    if (token != null) {
        [...nav.querySelectorAll('.user-nav')].forEach(e => e.style.display = '');
        [...nav.querySelectorAll('.guest-nav')].forEach(e => e.style.display = 'none');
    } else {
        [...nav.querySelectorAll('.user-nav')].forEach(e => e.style.display = 'none');
        [...nav.querySelectorAll('.guest-nav')].forEach(e => e.style.display = '');
    }
}