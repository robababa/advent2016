-- initialize the building
select init_building();
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(1,2,'4G','5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(2,3,'5M','5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(3,4,'5M','5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(4,3,'5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(3,2,'5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(2,3,'4G','5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(3,4,'4G','5G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(4,3,'4G');
select floor, slot, thing from building order by floor desc, slot \crosstabview
select move(3,2,'4G');
select floor, slot, thing from building order by floor desc, slot \crosstabview

select move(2,3,'4M','4G');
select floor, slot, thing from building order by floor desc, slot \crosstabview

