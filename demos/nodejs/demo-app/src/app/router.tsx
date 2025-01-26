import { Outlet, createBrowserRouter } from 'react-router-dom';
export const CATEGORIES_LISTS_ROUTE = '/views/category-lists';
import CategoryListsPage from './views/categories-lists/page';
import SQLConsolePage from './views/sql-console/page';
export const SQL_CONSOLE_ROUTE = '/sql-console';
import ViewsLayout from './views/layout';
import EntryPage from './page';

/**
 * Navigate to this route after authentication
 */
export const DEFAULT_ENTRY_ROUTE = CATEGORIES_LISTS_ROUTE;

export const router = createBrowserRouter([
  {
    path: '/',
    element: <EntryPage />
  },
  {
    element: (
      <ViewsLayout>
        <Outlet />
      </ViewsLayout>
    ),
    children: [
      {
        path: CATEGORIES_LISTS_ROUTE,
        element: <CategoryListsPage />
      },
      {
        path: SQL_CONSOLE_ROUTE,
        element: <SQLConsolePage />
      }
    ]
  }
]);
