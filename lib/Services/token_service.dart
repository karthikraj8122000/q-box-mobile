
import 'package:localstorage/localstorage.dart';

class TokenService {
  String tokenKey = "token";
  String categoriesKey = "categories";
  String citiesKey = "cities";
  String featuredCompaniesKey = "featuredcompanies";
  final LocalStorage localStorage = LocalStorage('localstorage_app');

  signOut() {
    localStorage.clear();  // Just clear all items, no need to capture the result
  }

  saveToken(token) {
    localStorage.deleteItem(tokenKey);  // Removes the old token, no result needed
    localStorage.setItem(tokenKey, token);  // Sets the new token
  }

  getToken() {
    return localStorage.getItem(tokenKey);  // Returns the token value
  }

  saveUser(user) async {
    await localStorage.setItem('user', user);  // No result needed
  }

  getUser() async {
    return await localStorage.getItem('user');  // Returns the user data
  }

  removeStorage() async {
    await localStorage.clear();  // Clears storage, no result needed
  }

  saveCategories(categories) {
    localStorage.deleteItem(categoriesKey);  // Removes old categories
    localStorage.setItem(categoriesKey, categories);  // Sets new categories
  }

  getCategories() {
    return localStorage.getItem(categoriesKey);  // Returns categories
  }

  saveCities(cities) {
    localStorage.deleteItem(citiesKey);  // Removes old cities
    localStorage.setItem(citiesKey, cities);  // Sets new cities
  }

  getCities() {
    return localStorage.getItem(citiesKey);  // Returns cities
  }

  saveFeaturedCompanies(featuredcompanies) {
    localStorage.deleteItem(featuredCompaniesKey);  // Removes old featured companies
    localStorage.setItem(featuredCompaniesKey, featuredcompanies);  // Sets new companies
  }

  getFeaturedCompanies() {
    return localStorage.getItem(featuredCompaniesKey);  // Returns featured companies
  }
}
