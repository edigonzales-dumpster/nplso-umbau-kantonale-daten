SELECT 
    --gs.fid, gem.bfs_gemein, gem.the_geom, gs.the_geom, gs."zone"
    count(*)
FROM
    agi_gemgre.gemeindegrenze AS gem, 
    afu_gws.public_aww_gszoar AS gs
--WHERE ST_Intersects(gem.the_geom, gs.the_geom)
--WHERE ST_ContainsProperly(gem.the_geom, gs.the_geom)
--WHERE ST_Intersects(gem.the_geom, gs.the_geom)
WHERE ST_Intersects(gem.the_geom, ST_Buffer(gs.the_geom, -1.0))
--AND NOT ST_Touches(gem.the_geom, gs.the_geom)
--ORDER BY gs.fid;
    

-- Am sinnvollsten? kleiner minus buffer und INTERSECT -> dann ist die Aussage relativ belastbar. 792 vs 763 vs. 665 (original)