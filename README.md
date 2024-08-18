# DrugFieldManager

## Main Features

1. **Dynamic Drug Field Management:**
   - Create dedicated zones for drug fields, including a large Trigger Zone that triggers the creation of plants in a smaller Crop Zone, with adjustable size in the config.
   - Plants only appear when players enter the Trigger Zone.

2. **Stock and Resupply System:**
   - Each field has a defined stock of available crops. Once this stock is depleted, the field will no longer produce drugs until an automatic resupply occurs.
   - The system can reset stocks based on server configuration, allowing control over drug production on the server.

3. **Plant Prop Creation:**
   - Plants are randomly generated within the Crop Zone, with customizable properties such as the prop type, animation, required item, and number of props.
   - Harvest interaction on each prop allows players to collect drugs.

4. **Player Tracking and Logging:**
   - Integrated with a Discord logging system to track players entering the fields, allowing admins to monitor illegal activity on the server.
   - Player interactions with plants are also tracked, offering complete transparency over harvested crops.

5. **Automatic Field Reset:**
   - Once a field’s stock is depleted, an automatic reset process is triggered, reloading the stock after a defined period.
   - This reset system ensures that fields are not constantly overloaded, allowing for balanced management of the drug economy on the server.

## Usage

- **Illegal Drug Cultivation:** Create fields for cannabis, coca, or other illegal plants where players can grow and harvest drugs to sell or use.
- **Drug Economy Management:** Control supply and demand on your server by setting limited drug stocks, automatically reset after depletion.
- **Enhanced Immersion:** Players must find and enter Trigger Zones to activate drug production, adding a layer of realism and strategy to their illegal activities.

## Installation and Configuration

1. **Download** and place the script in your server’s `resources` folder.
2. **Add** the script to your `server.cfg` file using `start DrugFieldManager`.
3. **Configure** your fields, stocks, and reset cycles in the `config.lua` file to suit your specific needs.
