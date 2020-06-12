{{- define "crd" -}}
{{ template "boilerplate" }}

package {{ .APIVersion }}

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	ackv1alpha1 "github.com/aws/aws-service-operator-k8s/apis/core/v1alpha1"
)

// {{ .CRD.Kind }}Spec defines the desired state of {{ .CRD.Kind }}
type {{ .CRD.Kind }}Spec struct {
	{{- range $attrName, $attr := .CRD.SpecAttrs }}
	{{ $attr.Names.GoExported }} {{ $attr.GoType }} `json:"{{ $attr.Names.GoUnexported }},omitempty" aws:"{{ $attr.Names.Original }}"`
{{- end }}
}

// {{ .CRD.Kind }}Status defines the observed state of {{ .CRD.Kind }}
type {{ .CRD.Kind }}Status struct {
	// All CRs managed by ACK will have a common `Status.ACKResourceMetadata`
	// member that is used to contain resource sync state, account ownership,
	// constructed ARN for the resource
	ACKResourceMetadata *ackv1alpha1.ResourceMetadata `json:"ackResourceMetadata"`
	{{- range $attrName, $attr := .CRD.StatusAttrs }}
	{{ $attr.Names.GoExported }} {{ $attr.GoType }} `json:"{{ $attr.Names.GoUnexported }},omitempty" aws:"{{ $attr.Names.Original }}"`
{{- end }}
}

// {{ .CRD.Kind }} is the Schema for the {{ .CRD.Plural }} API
type {{ .CRD.Kind }} struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec   {{ .CRD.Kind }}Spec   `json:"spec,omitempty"`
	Status {{ .CRD.Kind }}Status `json:"status,omitempty"`
}

// {{ .CRD.Kind }}List contains a list of {{ .CRD.Kind }}
type {{ .CRD.Kind }}List struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items []{{ .CRD.Kind }} `json:"items"`
}

func init() {
	SchemeBuilder.Register(&{{ .CRD.Kind }}{}, &{{ .CRD.Kind }}List{})
}
{{- end -}}
