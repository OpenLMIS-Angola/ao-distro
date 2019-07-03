DROP MATERIALIZED VIEW IF EXISTS stock_adjustments_view;

CREATE MATERIALIZED VIEW stock_adjustments_view AS
SELECT scli.occurreddate, scli.quantity,
r.name AS reason_name, r.reasoncategory,
o.fullproductname AS product_name, o.code AS product_code,
p.name AS program_name, p.code AS program_code,
f.name AS facility_name, f.code AS facility_code,
z.name AS zone_name,
CASE
    WHEN r.reasontype = 'CREDIT' THEN 'Negative'
    WHEN r.reasontype = 'DEBIT' THEN 'Positive'
    ELSE 'Unknown' END as reason_type
FROM stockmanagement.stock_cards sc
LEFT JOIN stockmanagement.stock_card_line_items scli ON sc.id = scli.stockcardid
LEFT JOIN stockmanagement.stock_card_line_item_reasons r ON scli.reasonid = r.id
LEFT JOIN referencedata.orderables o ON sc.orderableid = o.id
LEFT JOIN referencedata.programs program ON sc.programid = program.id
LEFT JOIN referencedata.facilities facility ON sc.facilityid = facility.id
LEFT JOIN referencedata.geographic_zones district ON facility.geographiczoneid = district.id
LEFT JOIN referencedata.geographic_zones province ON district.parentid = province.id;
LEFT JOIN referencedata.geographic_levels province ON p. = z.id;
