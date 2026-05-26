@tool
extends EditorScript

const XML_PATH = "res://assets/Tilemap/spritesheet-tiles-double.xml"
const PNG_PATH = "res://assets/Tilemap/spritesheet-tiles-double.png"
const OUTPUT_PATH = "res://assets/Tilemap/spritesheet-tiles-double.tres"

const TILE_SIZE   = 128
const PADDING     = 1  # tile'lar arası boşluk (0, 129, 258... farkı buradan)

func _run() -> void:
	var texture = load(PNG_PATH)
	if not texture:
		push_error("PNG yüklenemedi: " + PNG_PATH)
		return

	var tile_set = TileSet.new()
	tile_set.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)

	var source = TileSetAtlasSource.new()
	source.texture = texture
	source.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	source.separation = Vector2i(PADDING, PADDING)  # 1px padding

	var xml = XMLParser.new()
	if xml.open(XML_PATH) != OK:
		push_error("XML açılamadı: " + XML_PATH)
		return

	var tile_count = 0
	var name_to_coords: Dictionary = {}

	while xml.read() == OK:
		if xml.get_node_type() != XMLParser.NODE_ELEMENT:
			continue
		if xml.get_node_name() != "SubTexture":
			continue

		var name = xml.get_named_attribute_value("name")
		var x    = int(xml.get_named_attribute_value("x"))
		var y    = int(xml.get_named_attribute_value("y"))

		# Padding dahil: (x / (128+1)), (y / (128+1))
		var col = x / (TILE_SIZE + PADDING)
		var row = y / (TILE_SIZE + PADDING)
		var atlas_coords = Vector2i(col, row)

		if source.get_tile_at_coords(atlas_coords) == Vector2i(-1, -1):
			source.create_tile(atlas_coords)

		name_to_coords[name] = atlas_coords
		tile_count += 1

	var source_id = tile_set.add_source(source)
	ResourceSaver.save(tile_set, OUTPUT_PATH)

	print("=== TileSet oluşturuldu ===")
	print("Toplam tile: %d" % tile_count)
	print("Source ID: %d" % source_id)
	print("Kayıt: %s" % OUTPUT_PATH)
	print("")
	print("Tile koordinat listesi (isim → atlas coords):")
	for tile_name in name_to_coords:
		print("  %s → %s" % [tile_name, name_to_coords[tile_name]])
