@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'entity for sutdent attachment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_student_att as select from ztb_student_att 
association  to parent ZI_STUDENT_501 as _student on $projection.Id =   _student.Id
{
    key attach_id as AttachId,
    id as Id,
    @EndUserText.label: 'Attachment'
    @Semantics.largeObject : { 
      mimeType: 'Minetype' , 
      fileName: 'Filename', 
      contentDispositionPreference: #INLINE 
    }
    attachment as Attachment,
    comments as Comments,
    minetype as Minetype,
    filename as Filename , 
    _student 
    
    
}
