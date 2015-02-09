package restcora;

import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Relationship;
import org.neo4j.graphdb.index.Index;
import org.neo4j.rest.graphdb.RestGraphDatabase;

import common.RelTypes;

public class PrintPaperData {
	public static void main(String[] args) {
		// The title of the paper.
		String paperTitle = "Effective Graph Clustering for Path Queries in Digital Map Databases";

		String DB_PATH = "http://puccini.cs.lth.se:7474/db/data";
		GraphDatabaseService db = new RestGraphDatabase(DB_PATH);
		registerShutdownHook(db);

		Index<Node> paperIndex = db.index().forNodes("paperIndex");
		Node paper = paperIndex.get("title", paperTitle).getSingle();
		System.out.println(paperTitle + ", " + paper.getProperty("year"));
		System.out.print("    Authors: ");
		for (Relationship r : paper.getRelationships(RelTypes.AUTHORED_BY)) {
			Node author = r.getEndNode();
			System.out.print(author.getProperty("lastName") + ","
					+ (char)((Integer) author.getProperty("initial")).intValue() + " / ");
		}
		System.out.println();

		db.shutdown();
	}

	private static void registerShutdownHook(final GraphDatabaseService db) {
		Runtime.getRuntime().addShutdownHook(new Thread() {
			@Override
			public void run() {
				db.shutdown();
			}
		});
	}
}
