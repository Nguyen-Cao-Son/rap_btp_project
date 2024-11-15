@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view to read domain value ZDOM_GENDER1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_READ_DOMAIN_SONNC as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_GENDER1'  )
{
    key domain_name,
    key value_position,
    @Semantics.language: true
    key language,
    value_low as Value ,
    @Semantics.text: true 
    text as Description
  
    
} 

