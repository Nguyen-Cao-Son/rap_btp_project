@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view interface'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI: { headerInfo :  { typeName : 'Course' ,  description :  { type : #STANDARD , label : 'test' , value : 'course_desc' } } 

}
define view entity ZI_AR_SONNC
  as select from ztb_course_sonnc 
  // association to parent zi_student_500 must use with composition in cds view paret
  association to parent ZI_STUDENT_500 as _student on $projection.Id = _student.Id
  association [1..1] to ZI_COURSE_SONNC       as _course  on $projection.Course = _course.Value 
  association [1..1] to ZI_SEM_SONNC as _semester on $projection.Semester = _semester.Value 
  association [1..1] to ZI_SEMRES_SON as _semres on $projection.Semresult = _semres.Value

{ 
  key ztb_course_sonnc.id        as Id,
  key ztb_course_sonnc.course    as Course,
  key ztb_course_sonnc.semester  as Semester,
      ztb_course_sonnc.semresult as Semresult,
      _course.Description as course_desc , 
      _semester.Description as semester_desc , 
      _semres.Description as semres_desc , 
      _student,
      _course , 
      _semester  , 
      _semres 

}
