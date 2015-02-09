package common;

import org.neo4j.graphdb.RelationshipType;

public enum RelTypes implements RelationshipType {
	SUPER_CLASSIFICATION, CLASSIFIED_AS, CITES, AUTHORED_BY
}