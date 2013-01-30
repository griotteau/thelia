<?php

namespace Thelia\Model\map;

use \RelationMap;
use \TableMap;


/**
 * This class defines the structure of the 'tax' table.
 *
 *
 *
 * This map class is used by Propel to do runtime db structure discovery.
 * For example, the createSelectSql() method checks the type of a given column used in an
 * ORDER BY clause to know whether it needs to apply SQL to make the ORDER BY case-insensitive
 * (i.e. if it's a text column type).
 *
 * @package    propel.generator.Thelia.Model.map
 */
class TaxTableMap extends TableMap
{

    /**
     * The (dot-path) name of this class
     */
    const CLASS_NAME = 'Thelia.Model.map.TaxTableMap';

    /**
     * Initialize the table attributes, columns and validators
     * Relations are not initialized by this method since they are lazy loaded
     *
     * @return void
     * @throws PropelException
     */
    public function initialize()
    {
        // attributes
        $this->setName('tax');
        $this->setPhpName('Tax');
        $this->setClassname('Thelia\\Model\\Tax');
        $this->setPackage('Thelia.Model');
        $this->setUseIdGenerator(true);
        // columns
        $this->addPrimaryKey('ID', 'Id', 'INTEGER', true, null, null);
        $this->addColumn('RATE', 'Rate', 'FLOAT', true, null, null);
        $this->addColumn('CREATED_AT', 'CreatedAt', 'TIMESTAMP', false, null, null);
        $this->addColumn('UPDATED_AT', 'UpdatedAt', 'TIMESTAMP', false, null, null);
        // validators
    } // initialize()

    /**
     * Build the RelationMap objects for this table relationships
     */
    public function buildRelations()
    {
        $this->addRelation('TaxRuleCountry', 'Thelia\\Model\\TaxRuleCountry', RelationMap::ONE_TO_MANY, array('id' => 'tax_id', ), 'SET NULL', 'RESTRICT', 'TaxRuleCountrys');
        $this->addRelation('TaxI18n', 'Thelia\\Model\\TaxI18n', RelationMap::ONE_TO_MANY, array('id' => 'id', ), 'CASCADE', null, 'TaxI18ns');
    } // buildRelations()

    /**
     *
     * Gets the list of behaviors registered for this table
     *
     * @return array Associative array (name => parameters) of behaviors
     */
    public function getBehaviors()
    {
        return array(
            'timestampable' => array('create_column' => 'created_at', 'update_column' => 'updated_at', 'disable_updated_at' => 'false', ),
            'i18n' => array('i18n_table' => '%TABLE%_i18n', 'i18n_phpname' => '%PHPNAME%I18n', 'i18n_columns' => 'title, description', 'locale_column' => 'locale', 'default_locale' => '', 'locale_alias' => '', ),
        );
    } // getBehaviors()

} // TaxTableMap