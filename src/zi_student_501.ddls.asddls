@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity for sutdent 500'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_STUDENT_501
  as select from ztb_im_rap_500 
  composition [1..*] of zi_student_att as _Attachment 

 
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
      locallastchangeby   as Locallastchangeby  ,
      _Attachment
   
   
        
        
        
  
}
