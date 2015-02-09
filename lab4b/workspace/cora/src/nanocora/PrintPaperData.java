package nanocora;

import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.Node;
import org.neo4j.graphdb.Relationship;
import org.neo4j.graphdb.Transaction;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;
import org.neo4j.graphdb.factory.GraphDatabaseSettings;
import org.neo4j.graphdb.index.Index;
import common.RelTypes;

public class PrintPaperData {
	public static void main(String[] args) {
		// The title of the paper.
		String paperTitle = "p1";

		// Open the database read only.
		String DB_PATH = "nanocora.db";
		GraphDatabaseService db = new GraphDatabaseFactory()
				.newEmbeddedDatabaseBuilder(DB_PATH)
				.setConfig(GraphDatabaseSettings.read_only, "true")
				.newGraphDatabase();
		registerShutdownHook(db);

		// Wrap the database operations in a transaction.
		try (Transaction tx = db.beginTx()) {
			// Database operations.
			Index<Node> paperIndex = db.index().forNodes("paperIndex");
			Node paper = paperIndex.get("title", paperTitle).getSingle();
			System.out.println(paperTitle + ", " + paper.getProperty("year"));
			System.out.print("    Authors: ");
			for (Relationship r : paper.getRelationships(RelTypes.AUTHORED_BY)) {
				Node author = r.getEndNode();
				System.out.print(author.getProperty("lastName") + ","
						+ author.getProperty("initial") + " / ");
			}
			System.out.println();
			// Mark the transaction as successful. The transaction will be
			// committed when it's closed. Use tx.failure() to roll back
			// the transaction.
			tx.success();
		} catch (Exception e) {
			e.printStackTrace();
		}
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
