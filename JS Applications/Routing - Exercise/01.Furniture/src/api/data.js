import * as api from './api.js';

const host = 'http://localhost:3030';
api.settings.host = host;

export const login = api.login;
export const register = api.register;
export const logout = api.logout;

// implement application-specific requests

// GET all furniture !!!!!!
export async function getFurniture() {
    return await api.get(host + '/data/catalog');
}

//GET furniture by id (Furniture Details ) !!!!!
export async function getItemById(id) {
    return await api.get(host + '/data/catalog/' + id);
}

// GET My furniture
export async function getMyFurniture() {
    const userId = sessionStorage.getItem('userId');
    return await api.get(host + `/data/catalog?where=_ownerId%3D%22${userId}%22`);
}

// POST create Furniture !!!!!!!
export async function createRecord(data) {
    return await api.post(host + '/data/catalog/', data);
}

// EDIT furniture !!!!!!
export async function editRecord(id, data) {
    return await api.put(host + '/data/catalog/' + id, data);
}

// DELETE furniture !!!!!!
export async function deleteRecord(id) {
    return await api.del(host + '/data/catalog/' + id);
}