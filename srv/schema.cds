using my.bookshop as my from '../db/schema';

service CatalogService {
    @readonly entity BooksAnalytics as projection on my.Books;
}