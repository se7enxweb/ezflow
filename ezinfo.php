<?php
/**
 * File containing the ezflowInfo class.
 *
 * @copyright Copyright (C) 1999-2014 eZ Systems AS. All rights reserved.
 * @license http://www.gnu.org/licenses/gpl-2.0.txt GNU General Public License v2.0 (or any later version)
 * @version 6.1.3
 * @package ezflow
 */

class ezflowInfo
{
    static function info()
    {
        return array(
            'Name' => 'eZ Flow LS',
            'Version' => '6.1.3',
            'Copyright' => 'Copyright (C) 1999-2014 eZ Systems AS. All rights reserved.',
            'License' => 'GNU General Public License v2.0 (or any later version)',
            'Info_url' => 'https://github.com/se7enxweb/ezflow',
            'Includes the following third-party software' => array(
                'Name' => 'Prototype JavaScript framework',
                'Version' => '1.5.1.1',
                'License' => 'MIT-style license, (c) 2005-2007 Sam Stephenson',
                'For more information' => 'http://www.prototypejs.org/' ),
        );
    }
}

?>
