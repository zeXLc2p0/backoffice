create table screeningdata
(
PartitionKey varchar(400),
RowKey varchar(400) primary key,
Timestamp datetimeoffset,
FillingOutFor varchar(400),
PUMA varchar(400),
Age int,
Sex varchar(400),
Symptomatic bit,
ScanCode varchar(400),
KitOrdered bit,
Locale varchar(400),
UtmSource varchar(400),
UtmMedium varchar(400),
UtmCampaign varchar(400),
UtmAudience varchar(400),
PacificTimestamp datetimeoffset,
ScreenerSymptoms varchar(400),
SymptomCount int
)
;

create index ix_screeningdata_timestamp
on screeningdata(Timestamp)
;

create index ix_screeningdata_pacific_timestamp
on screeningdata(PacificTimestamp )
;


create table screeningsymptoms
(
RowKey varchar(400),
SymptomId int
)
;

alter table screeningsymptoms
add constraint fk_RowKey foreign key (RowKey)
references screeningdata (RowKey)
on delete cascade
on update cascade
;

create index ix_screeningsymptoms_rowkey
on screeningsymptoms (RowKey)
;


create table watermarktable
(
TableName varchar(255),
WatermarkValue datetimeoffset,
)
;

INSERT INTO watermarktable
VALUES ('screeningdata','12/1/1980 12:00:00 AM');

GO

create procedure usp_write_watermark @LastModifiedtime datetimeoffset, @TableName varchar(50)
as
begin

update watermarktable
set [WatermarkValue] = @LastModifiedtime
where [TableName] = @TableName
end
;

grant EXECUTE on usp_write_watermark to scan_healthbot_automation
;

GO

create procedure usp_process_new_screening_records @StartTime datetimeoffset
as

begin

update screeningdata
set PacificTimestamp = Timestamp AT TIME ZONE 'Pacific Standard Time'
where Timestamp > @StartTime
;

insert into screeningsymptoms(RowKey, SymptomId)
select RowKey, value as symptom
from screeningdata
cross apply STRING_SPLIT(ScreenerSymptoms, ',')
where Timestamp > @StartTime
and value is not null and len(value) > 0 and value <> '0'
order by RowKey, symptom
;

update screeningdata
set SymptomCount = ss.count
from
(select s1.RowKey, count(distinct(SymptomId)) as count
from screeningdata s1
left join screeningsymptoms s2 on s1.RowKey = s2.RowKey
group by s1.RowKey) ss
where screeningdata.Timestamp > @StartTime AND screeningdata.RowKey = ss.RowKey;
end
;

grant EXECUTE on usp_process_new_screening_records to scan_healthbot_automation
;

GO


create function [dbo].[WeekStartDate] (@MidWeekDate DateTime) returns DateTime
as

begin

declare @WeekCommence DateTime

set @MidWeekDate = DATEADD(dd, DATEDIFF(d, 0, @MidWeekDate),0)
set @WeekCommence = DATEADD(d, -((@@DATEFIRST + DATEPART(dw, @MidWeekDate) -1) % 7), @MidWeekDate)

return @WeekCommence

end
;

GO

create schema dim;

GO


create table dim.date
(
DimDateID VARCHAR(20),
DimDateDate date,
DimDateDay VARCHAR(20),
DimDateDayOfWeek VARCHAR(20),
DimDateDayOfYear VARCHAR(20),
DimDateWeekOfYear VARCHAR(20),
DimDateWeekOfMonth VARCHAR(20),
DimDateMonth VARCHAR(20),
DimDateMonthName varchar(20),
DimDateQuarter VARCHAR(20),
DimDateYear VARCHAR(20),
DimDateWeekStart date
)
;

create index ix_dimdate_dimdatedate
on dim.date(DimDateDate );


declare @todate datetime,
@fromdate datetime

set @fromdate = '1990-01-01'
set @todate = '2050-12-31'
;

With DateSequence( [Date] ) as
(
select @fromdate as [Date]
union all
select dateadd(day, 1, [Date])
from DateSequence
where Date < @todate
)

insert into dim.date
select
CONVERT(VARCHAR,[Date],112) as ID,
[Date] as [Date],
DATEPART(DAY,[Date]) as [Day],
DATENAME(dw, [Date]) as [DayOfWeek],
DATEPART(DAYOFYEAR,[Date]) as [DayOfYear],
DATEPART(WEEK,[Date]) as [WeekOfYear],
DATEPART(WEEK,[Date]) +
1 - DATEPART(WEEK,CAST(DATEPART(MONTH,[Date]) AS VARCHAR)
+ '/1/' + CAST(DATEPART(YEAR,[Date]) AS VARCHAR)) as [WeekOfMonth],
DATEPART(MONTH,[Date]) as [Month],
DATENAME(MONTH,[Date]) as [MonthName],
DATEPART(QUARTER,[Date]) as [Quarter],
DATEPART(YEAR,[Date]) as [Year],
dbo.WeekStartDate([Date])
from DateSequence option (MaxRecursion 0)
;

GO


create view vw_screeningdata
as
(
select PartitionKey as ZipCode,
RowKey as VisitId,
PacificTimestamp as VisitTimestampPacific,
cast (PacificTimestamp as date) as VisitDatePacific,
case when FillingOutFor = '0' then 'myself' when FillingOutFor = '1' then 'someone_else' end as FilllingOutFor,
PUMA as ZipCodeGrouper,
Age as Age,
Case when Age >= 80 then 80 else (Age / 10 * 10) end  as AgeDecade,
case when sex = '0' or sex= 'female' then 'female' when sex = '1' or sex = 'male' then 'male' when sex = 2 then 'other' when sex = 3 then 'prefer_not_to_say' end as Sex,
Symptomatic as BinarySymptomatic,
ScanCode as ScanCode,
KitOrdered as KitOrdered,
Locale as Locale,
UtmSource as UtmSource,
UtmMedium as UtmMedium,
UtmCampaign as UtmCampaign,
UtmAudience as UtmAudience,
ScreenerSymptoms as ScreenerSymptoms,
SymptomCount as SymptomCount,
case when SymptomCount > 0 then cast(1 as bit) else cast (0 as bit) end as CalculatedSymptomatic,
d.*

from screeningdata sd
join dim.date d on d.DimDateDate = cast (sd.PacificTimestamp as date)
);

GO


create view vw_screeningsymptoms
as
(
select RowKey as VisitId,
SymptomId,
case SymptomId
when '1' then 'fever'
when '2' then 'cough'
when '3' then 'shortness of breath'
when '4' then 'chills'
when '5' then 'repeated shaking with chills'
when '6' then 'muscle pain'
when '7' then 'headache'
when '8' then 'sore throat'
when '9' then 'loss of taste or smell'
when '10' then 'fever or chills'
when '11' then 'cough'
when '12' then 'shortness of breath or difficulty breathing'
when '13' then 'fatigue'
when '14' then 'muscle or body aches'
when '15' then 'headache'
when '16' then 'loss of taste or smell'
when '17' then 'sore throat'
when '18' then 'congestion or runny nose'
when '19' then 'nausea or vomiting'
when '20' then 'diarrhea'
end as SymptomDescription
from screeningsymptoms
);

ALTER TABLE dbo.screeningdata ALTER COLUMN ScanCode VARCHAR(MAX);
ALTER TABLE dbo.screeningdata ALTER COLUMN Locale VARCHAR(MAX);
ALTER TABLE dbo.screeningdata ALTER COLUMN UtmSource VARCHAR(MAX);
ALTER TABLE dbo.screeningdata ALTER COLUMN UtmMedium VARCHAR(MAX);
ALTER TABLE dbo.screeningdata ALTER COLUMN UtmCampaign VARCHAR(MAX);
ALTER TABLE dbo.screeningdata ALTER COLUMN UtmAudience VARCHAR(MAX);
ALTER TABLE dbo.screeningdata ALTER COLUMN ScreenerSymptoms VARCHAR(MAX);

