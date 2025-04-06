import ActivityKit
import WidgetKit
import SwiftUI


struct MeetingActivityView: View {
    let context: ActivityViewContext<MeetingAttributes>
    
    var body: some View {
        VStack{
            Text("Meeting in porgress")
                .font(.headline)
            HStack{
                Text(context.state.startTime, style: .timer)
            }
            
        }.padding()
        
    }
}

struct MeetingWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeetingAttributes.self) { context in
            MeetingActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "person.bust")
                        .foregroundColor(Color(UIColor.orange))
                        .padding()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.startTime, style: .timer)
                        .foregroundColor(Color(UIColor.orange))
                        .padding()
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack{
                        Text("Meeting in progress...")
                            .foregroundColor(Color(UIColor.orange))
                        
                    }.padding()
                    .frame(maxWidth: 180)
                }
            } compactLeading: {
                Image(systemName: "person.bust")
                    .foregroundColor(Color(UIColor.orange))
            } compactTrailing: {
                Text(context.state.startTime, style: .timer)
                    .foregroundColor(Color(UIColor.orange))
                    .frame(maxWidth: .minimum(50, 50), alignment: .leading)
            } minimal: {
                Text(context.state.startTime, style: .timer)
                    .foregroundColor(Color(UIColor.orange))
                    .frame(maxWidth: .minimum(50, 50), alignment: .leading)
            }
        }
    }
}
