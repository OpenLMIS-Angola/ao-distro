DROP MATERIALIZED VIEW IF EXISTS stock_adjustments_view;

CREATE MATERIALIZED VIEW stock_adjustments_view AS
SELECT line_item.occurreddate, line_item.quantity,
reason.name AS reason_name, reason.reasoncategory,
program.name AS program_name, program.code AS program_code,
facility.name AS facility_name, facility.code AS facility_code,
district.name AS district_name, district.code AS district_code,
province.name AS province_name, province.code AS province_code, district_level.levelnumber,
CONCAT(product.fullproductname, ' (', product.code, ')') as product,
CASE
    WHEN reason.reasontype = 'CREDIT' THEN 'Negativo Adjuste'
    WHEN reason.reasontype = 'DEBIT' THEN 'Positivo Adjuste'
    ELSE 'Desconhecido' END as reason_type
FROM stockmanagement.stock_cards card
LEFT JOIN stockmanagement.stock_card_line_items line_item ON card.id = line_item.stockcardid
LEFT JOIN stockmanagement.stock_card_line_item_reasons reason ON line_item.reasonid = reason.id
LEFT JOIN referencedata.orderables product ON card.orderableid = product.id
LEFT JOIN referencedata.programs program ON card.programid = program.id
LEFT JOIN referencedata.facilities facility ON card.facilityid = facility.id
LEFT JOIN referencedata.geographic_zones district ON facility.geographiczoneid = district.id
LEFT JOIN referencedata.geographic_zones province ON district.parentid = province.id
LEFT JOIN referencedata.geographic_levels district_level ON district.levelid = district_level.id
LEFT JOIN referencedata.geographic_levels province_level ON province.levelid = province_level.id
WHERE reason.reasontype IS NOT NULL;