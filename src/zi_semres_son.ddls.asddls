@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view to read domain value zdom_semres_sonnc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SEMRES_SON as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_SEMRES_SONNC'  )
{   
    @UI.hidden: true
    key domain_name,
    key value_position,
    @Semantics.language: true
    key language,
    value_low as Value ,
    @Semantics.text: true 
    text as Description
}
