import json

IN_FILE = "rivers_named.geojson"
OUT_FILE = "rivers_named_main.geojson"

wanted = {
    "Labe",
    "Vltava",
    "Morava",
    "Odra",
    "Dyje",
    "Ohře",
    "Berounka",
    "Sázava",
    "Jizera",
    "Orlice",
    "Chrudimka",
    "Cidlina",
    "Mže",
    "Radbuza",
    "Úhlava",
    "Otava",
    "Lužnice",
    "Svratka",
    "Svitava",
    "Bečva",
}

with open(IN_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

features = []
seen = set()

for feat in data.get("features", []):
    props = feat.get("properties") or {}
    name = props.get("name")
    if name in wanted:
        key = (name, json.dumps(feat.get("geometry"), sort_keys=True, ensure_ascii=False))
        if key not in seen:
            seen.add(key)
            features.append(feat)

out = {
    "type": "FeatureCollection",
    "name": "cz_main_rivers",
    "features": features,
}

with open(OUT_FILE, "w", encoding="utf-8") as f:
    json.dump(out, f, ensure_ascii=False, separators=(",", ":"))

print("Počet feature:", len(features))
print("Zapsáno do:", OUT_FILE)
