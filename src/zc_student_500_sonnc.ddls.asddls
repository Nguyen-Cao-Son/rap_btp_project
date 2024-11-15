@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for  student'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
} 
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_STUDENT_500_SONNC
  as projection on ZI_STUDENT_500 as student
{ 
@EndUserText.label: 'Student ID'
  key Id,
  @EndUserText.label: 'Frist Name'
      @Search.defaultSearchElement: true 
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      Fristname,
      @EndUserText.label: 'Last Name'
      Lastname,
      @EndUserText.label: 'Age'
      Age,
      @EndUserText.label: 'Course'
      Course,
      @EndUserText.label: 'Course duration'
      Courseduration ,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Gender'
      Gender,
      Genderdesc  ,
      @EndUserText.label: 'DOB'
      Dob, 
      @Semantics.systemDateTime.lastChangedAt: true
      Locallastchangeat , 
      @Semantics.user.lastChangedBy: true
      Locallastchangeby , 
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CACULATE_SONNC' 
      @EndUserText.label: 'Total Pay' 
      virtual BonusAmount : abap.int4 , 
      _acdemicres 
}

