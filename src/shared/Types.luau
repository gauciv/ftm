--!strict

export type Service = {
	Name: string,
	Init: (() -> ())?,
	Start: (() -> ())?,
}

export type Controller = {
	Name: string,
	Init: (() -> ())?,
	Start: (() -> ())?,
}

export type RemoteKind = "Event" | "Function"

export type PropSpec = {
	Key: string,
	Label: string?,
	Offset: Vector2,
	Size: Vector3,
	Color: Color3?,
	Rotation: number?,
}

export type Landmark = PropSpec & {
	ProblemSite: string?,
}

export type District = {
	Key: string,
	Name: string,
	GroupKey: string,
	Color: Color3,
	AngleDeg: number,
	Gate: PropSpec,
	NoticeBoard: PropSpec,
	Landmarks: {Landmark},
}

export type Place = {
	Key: string,
	Name: string,
	Position: Vector2,
	Size: Vector3,
	Color: Color3,
	Enterable: boolean,
	DoorSide: string,
	Rotation: number,
	Radius: number,
	Props: {PropSpec},
}

export type Yard = {
	Key: string,
	Name: string,
	Label: string,
	AngleDeg: number,
	RadiusScale: number,
	HalfExtent: number,
	FenceHeight: number,
	OfficeSize: Vector3,
	OfficeOffset: Vector2,
	OfficeColor: Color3,
	EntranceSign: PropSpec,
	Props: {PropSpec},
}

export type CityLayout = {
	Ground: {Size: number, Color: Color3},
	Districts: {District},
	Places: {Place},
	Plaza: {Position: Vector2, Radius: number, Color: Color3, Props: {PropSpec}},
	Yards: {Yard},
	Paths: {{Key: string, TargetKind: string, TargetKey: string}},
	Spawn: {Name: string, Offset: Vector2},
}

export type ProblemSpec = {
	Key: string,
	Label: string,
	DistrictKey: string,
	SurfaceCycle: number,
	StartValue: number,
	RisePerCycle: number,
}

export type ResidentTeaching = {ProblemKey: string, Text: string}

export type ResidentSpec = {
	Key: string,
	Name: string,
	Role: string,
	DistrictKey: string,
	Anchor: string,
	Dx: number,
	Dz: number,
	Teaches: {ResidentTeaching}?,
	Greet: {string},
	Gossip: {string}?,
}

export type NotebookEntry = {
	kind: "Heard" | "Board" | "Note",
	cycle: number,
	text: string,
}

export type BoardEntry = {label: string, percent: number, erupted: boolean}

return {}
