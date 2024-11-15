@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity for sutdent 500'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_STUDENT_500
  as select from ztb_im_rap_500
  association [0..*] to ZI_READ_DOMAIN_SONNC as _gender on $projection.Gender = _gender.Value
  composition [0..*] of ZI_AR_SONNC          as _acdemicres 
  
  
{
  key id                  as Id,
      fristname           as Fristname,
      lastname            as Lastname,
      age                 as Age,
      course              as Course,
      courseduration      as Courseduration,
      status              as Status,
      gender              as Gender,
      dob                 as Dob,
      @Semantics.systemDateTime.lastChangedAt: true
      locallastchangeat   as Locallastchangeat ,  
      @Semantics.user.lastChangedBy: true
      locallastchangeby   as Locallastchangeby ,
      _gender,
      _gender.Description as Genderdesc , 
      _acdemicres 
        
}
