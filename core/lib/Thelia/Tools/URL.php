<?php
/*************************************************************************************/
/*                                                                                   */
/*      Thelia	                                                                     */
/*                                                                                   */
/*      Copyright (c) OpenStudio                                                     */
/*	    email : info@thelia.net                                                      */
/*      web : http://www.thelia.net                                                  */
/*                                                                                   */
/*      This program is free software; you can redistribute it and/or modify         */
/*      it under the terms of the GNU General Public License as published by         */
/*      the Free Software Foundation; either version 3 of the License                */
/*                                                                                   */
/*      This program is distributed in the hope that it will be useful,              */
/*      but WITHOUT ANY WARRANTY; without even the implied warranty of               */
/*      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                */
/*      GNU General Public License for more details.                                 */
/*                                                                                   */
/*      You should have received a copy of the GNU General Public License            */
/*	    along with this program. If not, see <http://www.gnu.org/licenses/>.         */
/*                                                                                   */
/*************************************************************************************/

namespace Thelia\Tools;

use Symfony\Component\HttpFoundation\Request;
use Thelia\Model\ConfigQuery;
use Thelia\Rewriting\RewritingRetriever;

class URL
{
    const PATH_TO_FILE = true;
    const WITH_INDEX_PAGE = false;

    public static function getIndexPage()
    {
        return ConfigQuery::read('base_url', '/') . "index_dev.php"; // FIXME !
    }

    /**
     * Returns the Absolute URL for a given path relative to web root. By default,
     * the index.php (or index_dev.php) script name is added to the URL, use
     * $path_only = true to get a path without the index script.
     *
     * @param string  $path       the relative path
     * @param array   $parameters An array of parameters
     * @param boolean $path_only  if true (PATH_TO_FILE), getIndexPage() will  not be added
     *
     * @return string The generated URL
     */
    public static function absoluteUrl($path, array $parameters = null, $path_only = self::WITH_INDEX_PAGE)
    {
         // Already absolute ?
        if (substr($path, 0, 4) != 'http') {

            $root = $path_only == self::PATH_TO_FILE ? ConfigQuery::read('base_url', '/') : self::getIndexPage();

            $base = rtrim($root, '/') . '/' . ltrim($path, '/');
        } else
            $base = $path;


        $queryString = '';

        if (! is_null($parameters)) {
            foreach ($parameters as $name => $value) {
                $queryString .= sprintf("%s=%s&", urlencode($name), urlencode($value));
            }
        }

        $sepChar = strstr($base, '?') === false ? '?' : '&';

        if ('' !== $queryString = rtrim($queryString, "&")) $queryString = $sepChar . $queryString;
        return $base . $queryString;
    }

    /**
     * Returns the Absolute URL to a administration view
     *
     * @param string $viewName   the view name (e.g. login for login.html)
     * @param mixed  $parameters An array of parameters
     *
     * @return string The generated URL
     */
    public static function adminViewUrl($viewName, array $parameters = array())
    {
        $path = sprintf("%s/admin/%s", self::getIndexPage(), $viewName); // FIXME ! view= should not be required, check routing parameters

        return self::absoluteUrl($path, $parameters);
    }

    /**
     * Returns the Absolute URL to a view
     *
     * @param string $viewName   the view name (e.g. login for login.html)
     * @param mixed  $parameters An array of parameters
     *
     * @return string The generated URL
     */
     public static function viewUrl($viewName, array $parameters = array())
     {
         $path = sprintf("%s?view=%s", self::getIndexPage(), $viewName);

         return self::absoluteUrl($path, $parameters);
     }

    /**
     * @param $view
     * @param $viewId
     * @param $viewLocale
     *
     * @return null|string
     */
    public static function retrieve($view, $viewId, $viewLocale)
    {
        $rewrittenUrl = null;
        if(ConfigQuery::isRewritingEnable()) {
            $retriever = new RewritingRetriever();
            $rewrittenUrl = $retriever->getViewUrl($view, $viewId, $viewLocale);
        }

        return $rewrittenUrl === null ? self::viewUrl($view, array($view . '_id' => $viewId, 'locale' => $viewLocale)) : $rewrittenUrl;
    }

    public static function retrieveCurrent(Request $request)
    {
        $rewrittenUrl = null;
        if(ConfigQuery::isRewritingEnable()) {
            $view = $request->query->get('view', null);
            $viewId = $view === null ? null : $request->query->get($view . '_id', null);
            $viewLocale = $request->query->get('locale', null);

            $allOtherParameters = $request->query->all();
            if($view !== null) {
                unset($allOtherParameters['view']);
            }
            if($viewId !== null) {
                unset($allOtherParameters[$view . '_id']);
            }
            if($viewLocale !== null) {
                unset($allOtherParameters['locale']);
            }

            $retriever = new RewritingRetriever();
            $rewrittenUrl = $retriever->getSpecificUrl($view, $viewId, $viewLocale, $allOtherParameters);
        }

        return $rewrittenUrl === null ? self::viewUrl($view, array($view . '_id' => $viewId, 'locale' => $viewLocale)) : $rewrittenUrl;
    }
}
